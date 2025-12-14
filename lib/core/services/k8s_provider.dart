import 'dart:io';
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kxs/shared/models/kubeconfig_model.dart';
import 'package:kubernetes/kubernetes.dart';
import 'package:yaml/yaml.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

part 'k8s_provider.g.dart';

class K8sState {
  final List<String> contexts;
  final String? currentContext;
  final String? kubeconfigPath;
  final KubernetesClient? client;
  final Client? httpClient;

  K8sState({
    this.contexts = const [],
    this.currentContext,
    this.kubeconfigPath,
    this.client,
    this.httpClient,
  });

  K8sState copyWith({
    List<String>? contexts,
    String? currentContext,
    String? kubeconfigPath,
    KubernetesClient? client,
    Client? httpClient,
  }) {
    return K8sState(
      contexts: contexts ?? this.contexts,
      currentContext: currentContext ?? this.currentContext,
      kubeconfigPath: kubeconfigPath ?? this.kubeconfigPath,
      client: client ?? this.client,
      httpClient: httpClient ?? this.httpClient,
    );
  }
}

@Riverpod(keepAlive: true)
class K8sController extends _$K8sController {
  @override
  FutureOr<K8sState> build() async {
    return K8sState(); 
  }

  Future<void> connect(KubeconfigModel config) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      print('Connecting to ${config.name}...');
      
      if (config.content == null || config.content!.isEmpty) {
        throw Exception('Config content is empty');
      }

      // 1. Write config to temp file (Always needed for Kubectl fallback)
      final tempDir = Directory.systemTemp;
      final fileName = 'kxs_config_${config.name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}.yaml';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(config.content!);
      print('Wrote kubeconfig to ${file.path}');

      // 2. Validate connection using kubectl (Quickest robust check)
      try {
        final result = await Process.run(
          'kubectl', 
          ['cluster-info', '--kubeconfig', file.path],
        );
        if (result.exitCode != 0) {
          throw Exception('Failed to connect: ${result.stderr}');
        }
        print('Kubectl probe successful');
      } catch (e) {
        // Only fail if we relying PURELY on kubectl? 
        // No, we want to fail fast if cluster is unreachable.
        // But maybe user doesn't have kubectl installed?
        print('Kubectl probe failed (non-critical if using API): $e');
        // If we want to support API-only environment, we shouldn't rethrow here 
        // unless we know API also fails. But for now, let's log and proceed.
      }

      // 3. Initialize KubernetesClient (For Default Mode)
      KubernetesClient? client;
      Client? httpClient;
      try {
        final tuple = await _createKubernetesClient(config.content!);
        client = tuple.$1;
        httpClient = tuple.$2;
        print('KubernetesClient initialized successfully');
      } catch (e) {
        print('Failed to initialize KubernetesClient: $e');
      }

      return state.value!.copyWith(
        currentContext: config.context,
        kubeconfigPath: file.path,
        client: client,
        httpClient: httpClient,
      );
    });
  }

  Future<(KubernetesClient, Client)> _createKubernetesClient(String yamlContent) async {
    final doc = loadYaml(yamlContent);
    if (doc == null) throw Exception('Invalid kubeconfig content');
    
    final clusters = (doc['clusters'] as List?) ?? [];
    final users = (doc['users'] as List?) ?? [];
    final contexts = (doc['contexts'] as List?) ?? [];
    final currentContextName = doc['current-context'] as String?;

    if (currentContextName == null) throw Exception('No current-context defined');

    // Find context
    final contextMap = contexts.firstWhere(
      (c) => c['name'] == currentContextName,
      orElse: () => throw Exception('Context $currentContextName not found'),
    );
    final context = contextMap['context'];
    final clusterName = context['cluster'];
    final userName = context['user'];

    // Find cluster
    final clusterMap = clusters.firstWhere(
      (c) => c['name'] == clusterName,
      orElse: () => throw Exception('Cluster $clusterName not found'),
    );
    final cluster = clusterMap['cluster'];
    final server = cluster['server'] as String;
    final caData = cluster['certificate-authority-data'] as String?;

    // Find user
    final userMap = users.firstWhere(
      (u) => u['name'] == userName,
      orElse: () => throw Exception('User $userName not found'),
    );
    final user = userMap['user'];
    
    // Auth Strategy
    String? token = user['token'] as String?; // Direct token
    final clientCertData = user['client-certificate-data'] as String?;
    final clientKeyData = user['client-key-data'] as String?;

    // Construct HTTP Client
    final securityContext = SecurityContext.defaultContext;
    bool useCustomClient = false;

    if (caData != null) {
      try {
        securityContext.setTrustedCertificatesBytes(base64Decode(caData));
        useCustomClient = true;
      } catch (e) {
        print('Failed to set CA cert: $e');
      }
    }

    if (clientCertData != null && clientKeyData != null) {
      try {
        securityContext.useCertificateChainBytes(base64Decode(clientCertData));
        securityContext.usePrivateKeyBytes(base64Decode(clientKeyData));
        useCustomClient = true;
      } catch (e) {
        print('Failed to set client certs: $e');
      }
    }

    Client httpClient;
    if (useCustomClient) {
       final ioHttpClient = HttpClient(context: securityContext);
       // Accept bad certs if needed (optional config?)
       ioHttpClient.badCertificateCallback = (cert, host, port) => true; 
       httpClient = IOClient(ioHttpClient);
    } else {
       httpClient = Client();
    }
    
    // Ensure token is not null if required (Empty string trick)
    final accessToken = token ?? '';

    final client = KubernetesClient(
      serverUrl: server,
      httpClient: httpClient, 
      accessToken: accessToken,
    );
    
    return (client, httpClient);
  }

  Future<ProcessResult> runKubectl(List<String> args) async {
    final kubePath = state.value?.kubeconfigPath;
    if (kubePath == null) {
      throw Exception('Not connected to any cluster');
    }
    
    return Process.run(
      'kubectl',
      [...args, '--kubeconfig', kubePath],
    );
  }

  Future<void> setContext(String context) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Switch in kubectl
      final result = await runKubectl(['config', 'use-context', context]);
      if (result.exitCode != 0) {
        throw Exception('Failed to set context: ${result.stderr}');
      }
      return state.value!.copyWith(currentContext: context);
      // Note: Re-initializing API client for new context would be needed if we supported context switching fully in API mode.
      // For now, we assume connect() is the primary entry.
    });
  }
}

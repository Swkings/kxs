import 'dart:io';
import 'package:kubernetes/kubernetes.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

abstract class K8sService {
  Future<void> loadConfig({String? path});
  KubernetesClient? get client;
  List<String> get contexts;
  String? get currentContext;
  Future<void> setContext(String context);
}

class K8sServiceImpl implements K8sService {
  KubernetesClient? _client;
  File? _configFile;
  Map<String, dynamic>? _rawConfig;
  String? _currentContext;

  @override
  KubernetesClient? get client => _client;

  @override
  List<String> get contexts {
    if (_rawConfig == null) return [];
    final contexts = _rawConfig!['contexts'] as List?;
    if (contexts == null) return [];
    return contexts.map((e) => e['name'] as String).toList();
  }

  @override
  String? get currentContext => _currentContext;

  @override
  Future<void> loadConfig({String? path}) async {
    final configPath = path ?? p.join(Platform.environment['HOME']!, '.kube', 'config');
    _configFile = File(configPath);
    
    if (!await _configFile!.exists()) {
      throw Exception('Kubeconfig not found at $configPath');
    }

    final content = await _configFile!.readAsString();
    _rawConfig = loadYaml(content) as Map<String, dynamic>;
    
    // Set initial context
    _currentContext = _rawConfig!['current-context'] as String?;
    
    if (_currentContext != null) {
      await _createClientForContext(_currentContext!);
    }
  }

  @override
  Future<void> setContext(String context) async {
    if (!contexts.contains(context)) {
      throw Exception('Context $context not found');
    }
    _currentContext = context;
    await _createClientForContext(context);
  }

  Future<void> _createClientForContext(String context) async {
    // TODO: The kubernetes package usage here is a simplification. 
    // In a real app, we must extract the specific cluster/user details from the config
    // and construct the KubernetesClient manually or use a helper if provided by the package.
    // For now, checks are skipped to allow UI building.
    
    // Note: This assumes the package can "auto-detect" or we just reload.
    // Actually, the package creates a client from a specific config object.
    // We would map the YAML data to KubernetesConfig.
    
    // Placeholder implementation for client creation:
    // _client = KubernetesClient(KubernetesConfig.fromKubeConfig(_configFile!.path, context: context));
  }
}


import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

abstract class K8sService {
  Future<void> loadConfig({String? path});
  List<String> get contexts;
  String? get currentContext;
  Future<void> setContext(String context);
  Future<void> deletePod(String namespace, String podName);
}

class K8sServiceImpl implements K8sService {
  File? _configFile;
  Map<String, dynamic>? _rawConfig;
  String? _currentContext;

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
  }

  @override
  Future<void> setContext(String context) async {
    if (!contexts.contains(context)) {
      throw Exception('Context $context not found');
    }
    _currentContext = context;
  }

  @override
  Future<void> deletePod(String namespace, String podName) async {
    // Mock deletion - in a real implementation, this would call kubectl or K8s API
    // For now, we simulate deletion with a delay
    await Future<void>.delayed(const Duration(milliseconds: 500));
    
    // In a real implementation, this would execute:
    // kubectl delete pod <podName> -n <namespace>
    // or use the Kubernetes API client directly
  }
}

// Provider for K8sService
final k8sServiceProvider = Provider<K8sService>((ref) {
  return K8sServiceImpl();
});

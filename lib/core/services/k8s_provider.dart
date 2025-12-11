import 'dart:io';
import 'package:kubernetes/kubernetes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

part 'k8s_provider.g.dart';

class K8sState {
  final List<String> contexts;
  final String? currentContext;
  final KubernetesClient? client;

  K8sState({
    this.contexts = const [],
    this.currentContext,
    this.client,
  });

  K8sState copyWith({
    List<String>? contexts,
    String? currentContext,
    KubernetesClient? client,
  }) {
    return K8sState(
      contexts: contexts ?? this.contexts,
      currentContext: currentContext ?? this.currentContext,
      client: client ?? this.client,
    );
  }
}

@Riverpod(keepAlive: true)
class K8sController extends _$K8sController {
  Map<String, dynamic>? _rawConfig;
  File? _configFile;

  @override
  FutureOr<K8sState> build() async {
    // Initial load
    await _loadConfig();
    return K8sState(
      contexts: _parseContexts(),
      currentContext: _rawConfig?['current-context'] as String?,
      client: null, // Client creation needs context
    ); 
  }

  Future<void> _loadConfig() async {
    final path = p.join(Platform.environment['HOME']!, '.kube', 'config');
    _configFile = File(path);
    if (await _configFile!.exists()) {
      final content = await _configFile!.readAsString();
      _rawConfig = loadYaml(content) as Map<String, dynamic>;
    }
  }

  List<String> _parseContexts() {
    if (_rawConfig == null) return [];
    final contexts = _rawConfig!['contexts'] as List?;
    if (contexts == null) return [];
    return contexts.map((e) => e['name'] as String).toList();
  }

  Future<void> setContext(String context) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
       // Set context logic
       // For now, update state
       // Real client creation would happen here
       return state.value!.copyWith(currentContext: context);
    });
  }
}

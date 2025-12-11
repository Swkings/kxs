import 'package:kxs/features/resources/repositories/pod_details_repository.dart';
import 'package:kxs/core/services/k8s_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pod_details_controller.g.dart';

@riverpod
PodDetailsRepository podDetailsRepository(Ref ref) {
  final k8sState = ref.watch(k8sControllerProvider);
  if (k8sState.asData?.value.client == null) {
    throw Exception('Kubernetes client not initialized');
  }
  return PodDetailsRepositoryImpl(k8sState.asData!.value.client!);
}

@riverpod
class PodYamlController extends _$PodYamlController {
  @override
  FutureOr<String> build(String namespace, String name) async {
    final repository = ref.watch(podDetailsRepositoryProvider);
    return repository.getPodYaml(namespace, name);
  }
}

@riverpod
class PodLogsController extends _$PodLogsController {
  @override
  FutureOr<String> build(String namespace, String name, {String? container}) async {
    final repository = ref.watch(podDetailsRepositoryProvider);
    return repository.getPodLogs(namespace, name, container: container);
  }
}

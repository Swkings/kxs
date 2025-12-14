import 'package:kxs/core/services/cluster_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pod_details_controller.g.dart';

@riverpod
class PodYamlController extends _$PodYamlController {
  @override
  FutureOr<String> build(String namespace, String name) async {
    final service = ref.watch(clusterServiceProvider);
    return service.getPodYaml(namespace, name);
  }
}

@riverpod
class PodLogsController extends _$PodLogsController {
  @override
  FutureOr<String> build(String namespace, String name, {String? container}) async {
    final service = ref.watch(clusterServiceProvider);
    return service.getPodLogs(namespace, name, container: container);
  }
}

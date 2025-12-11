import 'package:kxs/shared/models/node_model.dart';
import 'package:kxs/features/resources/repositories/nodes_repository.dart';
import 'package:kxs/core/services/k8s_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nodes_controller.g.dart';

@riverpod
NodesRepository nodesRepository(Ref ref) {
  final k8sState = ref.watch(k8sControllerProvider);
  if (k8sState.asData?.value.client == null) {
    throw Exception('Kubernetes client not initialized');
  }
  return NodesRepositoryImpl(k8sState.asData!.value.client!);
}

@riverpod
class NodesController extends _$NodesController {
  @override
  FutureOr<List<NodeModel>> build() async {
    final repository = ref.watch(nodesRepositoryProvider);
    return repository.getNodes();
  }
}

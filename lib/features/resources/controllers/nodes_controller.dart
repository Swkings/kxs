import 'package:kxs/shared/models/node_model.dart';
import 'package:kxs/core/interfaces/cluster_service.dart';
import 'package:kxs/core/services/cluster_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nodes_controller.g.dart';

@riverpod
class NodesController extends _$NodesController {
  @override
  FutureOr<List<NodeModel>> build() async {
    final service = ref.watch(clusterServiceProvider);
    return service.getNodes();
  }
}

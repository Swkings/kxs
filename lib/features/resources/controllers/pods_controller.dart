import 'package:kxs/core/interfaces/cluster_service.dart';
import 'package:kxs/core/services/cluster_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kxs/shared/models/pod_model.dart';

part 'pods_controller.g.dart';

@riverpod
class PodsController extends _$PodsController {
  @override
  FutureOr<List<PodModel>> build(String namespace) async {
    final service = ref.watch(clusterServiceProvider);
    return service.getPods(namespace);
  }
  
  Future<void> deletePod(String name) async {
     // TODO: Add deletePod to ClusterService interface
     throw UnimplementedError('Delete Pod not yet supported in ClusterService');
  }
}

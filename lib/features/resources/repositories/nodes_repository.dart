import 'package:kxs/shared/models/node_model.dart';
import 'package:kubernetes/kubernetes.dart';

abstract class NodesRepository {
  Future<List<NodeModel>> getNodes();
}

class NodesRepositoryImpl implements NodesRepository {
  final KubernetesClient client;

  NodesRepositoryImpl(this.client);

  @override
  Future<List<NodeModel>> getNodes() async {
    final dynamic dClient = client;
    final dynamic result = await dClient.coreV1.listNode();
    final items = result.items as List;
    
    return items.map((item) {
      final metadata = item.metadata;
      final status = item.status;
      final conditions = status.conditions as List?;
      final readyCondition = conditions?.firstWhere((c) => c.type == 'Ready', orElse: () => null);
      final isReady = readyCondition?.status == 'True';

      return NodeModel(
        name: (metadata?.name ?? 'Unknown').toString(),
        status: isReady ? 'Ready' : 'NotReady',
        version: (status?.nodeInfo?.kubeletVersion ?? 'Unknown').toString(),
        creationTimestamp: metadata?.creationTimestamp as DateTime?,
      );
    }).toList();
  }
}

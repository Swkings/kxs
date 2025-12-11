import 'package:kxs/shared/models/namespace_model.dart';
import 'package:kubernetes/kubernetes.dart';

abstract class NamespacesRepository {
  Future<List<NamespaceModel>> getNamespaces();
}

class NamespacesRepositoryImpl implements NamespacesRepository {
  final KubernetesClient client;

  NamespacesRepositoryImpl(this.client);

  @override
  Future<List<NamespaceModel>> getNamespaces() async {
    final dynamic dClient = client;
    final dynamic result = await dClient.coreV1.listNamespace();
    final items = result.items as List;
    
    return items.map((item) {
      final metadata = item.metadata;
      final status = item.status;
      
      return NamespaceModel(
        name: (metadata?.name ?? 'Unknown').toString(),
        status: (status?.phase ?? 'Unknown').toString(),
      );
    }).toList();
  }
}

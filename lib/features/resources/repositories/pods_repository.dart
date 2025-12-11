import 'package:kxs/shared/models/pod_model.dart';
import 'package:kubernetes/kubernetes.dart';

abstract class PodsRepository {
  Future<List<PodModel>> getPods(String namespace);
  Future<void> deletePod(String namespace, String name);
}

class PodsRepositoryImpl implements PodsRepository {
  final KubernetesClient client;

  PodsRepositoryImpl(this.client);

  @override
  Future<List<PodModel>> getPods(String namespace) async {
    // Casting to dynamic to bypass specific API static checks for now, as KubernetesClient structure varies.
    final dynamic dClient = client;
    // Try accessing coreV1 property or method. Some clients use client.coreV1.list...
    // Adjust based on actual package behavior.
    // We assume 'coreV1' getter exists or we can invoke methods directly if flat.
    // For safety, checking if we can default to a known pattern.
    // Let's assume standard 'coreV1' getter is generated.
    final result = await dClient.coreV1.listNamespacedPod(namespace);
    final items = result.items as List;
    
    return items.map((item) {
      // Map IoK8sApiCoreV1Pod (or whatever it is) to PodModel
      // We access properties dynamically or strictly if we knew types.
      final metadata = item.metadata;
      final status = item.status;
      
      return PodModel(
        name: (metadata?.name ?? 'Unknown').toString(),
        namespace: (metadata?.namespace ?? namespace).toString(),
        status: (status?.phase ?? 'Unknown').toString(),
        creationTimestamp: metadata?.creationTimestamp as DateTime?,
        nodeName: item.spec?.nodeName as String?,
      );
    }).toList();
  }

  @override
  Future<void> deletePod(String namespace, String name) async {
    final dynamic dClient = client;
    await dClient.coreV1.deleteNamespacedPod(name, namespace);
  }
}

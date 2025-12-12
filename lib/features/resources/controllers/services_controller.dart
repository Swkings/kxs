import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/shared/models/service_model.dart';

final servicesControllerProvider = FutureProvider.family<List<ServiceModel>, String>((ref, namespace) async {
  // Mock data - would normally fetch from K8s API
  await Future<void>.delayed(const Duration(milliseconds: 500));
  
  return [
    ServiceModel(
      name: 'kubernetes',
      namespace: namespace,
      type: 'ClusterIP',
      clusterIP: '10.96.0.1',
      ports: const [443],
      selector: const {},
      creationTimestamp: DateTime.now().subtract(const Duration(days: 30)),
    ),
    ServiceModel(
      name: 'nginx-service',
      namespace: namespace,
      clusterIP: '10.96.10.15',
      type: 'LoadBalancer',
      ports: const [80, 443],
      selector: const {'app': 'nginx'},
      creationTimestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ServiceModel(
      name: 'redis-service',
      namespace: namespace,
      type: 'ClusterIP',
      clusterIP: '10.96.20.30',
      ports: const [6379],
      selector: const {'app': 'redis'},
      creationTimestamp: DateTime.now().subtract(const Duration(days: 10)),
    ),
    ServiceModel(
      name: 'postgres-service',
      namespace: namespace,
      type: 'NodePort',
      clusterIP: '10.96.30.45',
      ports: const [5432, 30432],
      selector: const {'app': 'postgres'},
      creationTimestamp: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];
});

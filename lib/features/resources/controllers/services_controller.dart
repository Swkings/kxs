import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/core/services/cluster_service_provider.dart';
import 'package:kxs/shared/models/service_model.dart';

final servicesControllerProvider = FutureProvider.family<List<ServiceModel>, String>((ref, namespace) async {
  final clusterService = ref.watch(clusterServiceProvider);
  return clusterService.getServices(namespace);
});

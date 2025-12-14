import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/core/services/cluster_service_provider.dart';
import 'package:kxs/shared/models/deployment_model.dart';

final deploymentsControllerProvider = FutureProvider.family<List<DeploymentModel>, String>((ref, namespace) async {
  final clusterService = ref.watch(clusterServiceProvider);
  return clusterService.getDeployments(namespace);
});

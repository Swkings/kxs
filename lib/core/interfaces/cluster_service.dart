import 'package:kxs/shared/models/node_model.dart';
import 'package:kxs/shared/models/namespace_model.dart';
import 'package:kxs/shared/models/pod_model.dart';
import 'package:kxs/shared/models/service_model.dart';
import 'package:kxs/shared/models/deployment_model.dart';

abstract class ClusterService {
  Future<List<NodeModel>> getNodes();
  Future<List<NamespaceModel>> getNamespaces();
  Future<List<PodModel>> getPods(String namespace);
  Future<List<DeploymentModel>> getDeployments(String namespace);
  Future<String> getPodYaml(String namespace, String name);
  Future<String> getPodLogs(String namespace, String name, {String? container});
  Future<List<ServiceModel>> getServices(String namespace);
  Future<void> deletePod(String namespace, String name);
}

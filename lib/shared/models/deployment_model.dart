class DeploymentModel {
  final String name;
  final String namespace;
  final int replicas;
  final int readyReplicas;
  final int upToDateReplicas;
  final int availableReplicas;
  final String age;

  const DeploymentModel({
    required this.name,
    required this.namespace,
    required this.replicas,
    required this.readyReplicas,
    required this.upToDateReplicas,
    required this.availableReplicas,
    required this.age,
  });
}

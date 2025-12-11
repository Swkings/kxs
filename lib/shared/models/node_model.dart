class NodeModel {
  final String name;
  final String status;
  final String version;
  final DateTime? creationTimestamp;

  NodeModel({
    required this.name,
    required this.status,
    required this.version,
    this.creationTimestamp,
  });
}

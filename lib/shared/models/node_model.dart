class NodeModel {
  final String name;
  final String status;
  final String version;
  final DateTime? creationTimestamp;

  final String? role;
  final String? internalIP;
  final String? externalIP;
  final String? cpuCapacity;
  final String? memoryCapacity;

  NodeModel({
    required this.name,
    required this.status,
    required this.version,
    this.creationTimestamp,
    this.role,
    this.internalIP,
    this.externalIP,
    this.cpuCapacity,
    this.memoryCapacity,
  });
}

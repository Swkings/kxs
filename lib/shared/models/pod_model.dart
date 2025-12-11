class PodModel {
  final String name;
  final String namespace;
  final String status;
  final DateTime? creationTimestamp;
  final String? nodeName;

  PodModel({
    required this.name,
    required this.namespace,
    required this.status,
    this.creationTimestamp,
    this.nodeName,
  });
}

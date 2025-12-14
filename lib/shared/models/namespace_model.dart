class NamespaceModel {
  final String name;
  final String status;

  final DateTime? creationTimestamp;

  NamespaceModel({
    required this.name,
    required this.status,
    this.creationTimestamp,
  });
}

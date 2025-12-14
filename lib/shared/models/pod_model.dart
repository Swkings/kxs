class PodModel {
  final String name;
  final String namespace;
  final String status;
  final DateTime? creationTimestamp;
  final String? nodeName;

  final int? restarts;
  final String? age;
  final String? cpu;
  final String? memory;

  PodModel({
    required this.name,
    required this.namespace,
    required this.status,
    this.creationTimestamp,
    this.nodeName,
    this.restarts,
    this.age,
    this.cpu,
    this.memory,
  });
}

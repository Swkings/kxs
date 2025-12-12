class ServiceModel {
  final String name;
  final String namespace;
  final String type;
  final String clusterIP;
  final List<int> ports;
  final Map<String, String> selector;
  final DateTime? creationTimestamp;

  const ServiceModel({
    required this.name,
    required this.namespace,
    required this.type,
    required this.clusterIP,
    this.ports = const [],
    this.selector = const {},
    this.creationTimestamp,
  });

  ServiceModel copyWith({
    String? name,
    String? namespace,
    String? type,
    String? clusterIP,
    List<int>? ports,
    Map<String, String>? selector,
    DateTime? creationTimestamp,
  }) {
    return ServiceModel(
      name: name ?? this.name,
      namespace: namespace ?? this.namespace,
      type: type ?? this.type,
      clusterIP: clusterIP ?? this.clusterIP,
      ports: ports ?? this.ports,
      selector: selector ?? this.selector,
      creationTimestamp: creationTimestamp ?? this.creationTimestamp,
    );
  }
}

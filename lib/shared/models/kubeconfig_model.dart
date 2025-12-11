class KubeconfigModel {
  final String name;
  final String context;
  final String cluster;
  final String? user;
  final String? namespace;
  final bool isActive;
  final bool isValid;
  final String? errorMessage;

  const KubeconfigModel({
    required this.name,
    required this.context,
    required this.cluster,
    this.user,
    this.namespace,
    this.isActive = false,
    this.isValid = true,
    this.errorMessage,
  });

  KubeconfigModel copyWith({
    String? name,
    String? context,
    String? cluster,
    String? user,
    String? namespace,
    bool? isActive,
    bool? isValid,
    String? errorMessage,
  }) {
    return KubeconfigModel(
      name: name ?? this.name,
      context: context ?? this.context,
      cluster: cluster ?? this.cluster,
      user: user ?? this.user,
      namespace: namespace ?? this.namespace,
      isActive: isActive ?? this.isActive,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

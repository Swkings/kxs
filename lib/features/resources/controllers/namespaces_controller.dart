import 'package:kxs/shared/models/namespace_model.dart';
import 'package:kxs/features/resources/repositories/namespaces_repository.dart';
import 'package:kxs/core/services/k8s_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'namespaces_controller.g.dart';

@riverpod
NamespacesRepository namespacesRepository(Ref ref) {
  final k8sState = ref.watch(k8sControllerProvider);
  if (k8sState.asData?.value.client == null) {
    throw Exception('Kubernetes client not initialized');
  }
  return NamespacesRepositoryImpl(k8sState.asData!.value.client!);
}

@riverpod
class NamespacesController extends _$NamespacesController {
  @override
  FutureOr<List<NamespaceModel>> build() async {
    final repository = ref.watch(namespacesRepositoryProvider);
    return repository.getNamespaces();
  }
}

@riverpod
class SelectedNamespace extends _$SelectedNamespace {
  @override
  String build() {
    return 'default';
  }

  void select(String namespace) {
    state = namespace;
  }
}

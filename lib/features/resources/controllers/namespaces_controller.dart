import 'package:kxs/shared/models/namespace_model.dart';
import 'package:kxs/core/interfaces/cluster_service.dart';
import 'package:kxs/core/services/cluster_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'namespaces_controller.g.dart';

@riverpod
class NamespacesController extends _$NamespacesController {
  @override
  FutureOr<List<NamespaceModel>> build() async {
    final service = ref.watch(clusterServiceProvider);
    return service.getNamespaces();
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

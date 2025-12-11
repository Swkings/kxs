import 'package:kxs/core/services/k8s_provider.dart';
import 'package:kxs/features/resources/repositories/pods_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kxs/shared/models/pod_model.dart';

part 'pods_controller.g.dart';

@riverpod
PodsRepository podsRepository(Ref ref) {
  final k8sState = ref.watch(k8sControllerProvider);
  if (k8sState.asData?.value.client == null) {
    throw Exception('Kubernetes client not initialized');
  }
  return PodsRepositoryImpl(k8sState.asData!.value.client!);
}

@riverpod
class PodsController extends _$PodsController {
  @override
  FutureOr<List<PodModel>> build(String namespace) async {
    final repository = ref.watch(podsRepositoryProvider);
    return repository.getPods(namespace);
  }
  Future<void> deletePod(String name) async {
    final repository = ref.read(podsRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repository.deletePod(namespace, name);
      // Refresh list after deletion
      return repository.getPods(namespace);
    });
  }
}

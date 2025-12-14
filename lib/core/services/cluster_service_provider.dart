import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kxs/core/interfaces/cluster_service.dart';
import 'package:kxs/features/settings/providers/settings_provider.dart';
import 'package:kxs/core/services/k8s_provider.dart';
import 'package:kxs/core/services/kubectl_cluster_service.dart';
import 'package:kxs/core/services/api_cluster_service.dart';

part 'cluster_service_provider.g.dart';

@riverpod
ClusterService clusterService(Ref ref) {
  final useKubectl = ref.watch(settingsProvider);
  final k8sController = ref.watch(k8sControllerProvider.notifier);
  final k8sState = ref.watch(k8sControllerProvider);
  
  if (useKubectl) {
    return KubectlClusterService(k8sController);
  } else {
    // API Mode
    final state = k8sState.asData?.value;
    return ApiClusterService(state?.client, httpClient: state?.httpClient);
  }
}

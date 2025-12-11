// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'k8s_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(K8sController)
const k8sControllerProvider = K8sControllerProvider._();

final class K8sControllerProvider
    extends $AsyncNotifierProvider<K8sController, K8sState> {
  const K8sControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'k8sControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$k8sControllerHash();

  @$internal
  @override
  K8sController create() => K8sController();
}

String _$k8sControllerHash() => r'c9a3e810dc18b103fbefa17de193136ed3bb7d91';

abstract class _$K8sController extends $AsyncNotifier<K8sState> {
  FutureOr<K8sState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<K8sState>, K8sState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<K8sState>, K8sState>,
              AsyncValue<K8sState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

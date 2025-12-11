// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nodes_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(nodesRepository)
const nodesRepositoryProvider = NodesRepositoryProvider._();

final class NodesRepositoryProvider
    extends
        $FunctionalProvider<NodesRepository, NodesRepository, NodesRepository>
    with $Provider<NodesRepository> {
  const NodesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodesRepositoryHash();

  @$internal
  @override
  $ProviderElement<NodesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NodesRepository create(Ref ref) {
    return nodesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NodesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NodesRepository>(value),
    );
  }
}

String _$nodesRepositoryHash() => r'a7557a2282acc6641747f422d54ae441948e5c59';

@ProviderFor(NodesController)
const nodesControllerProvider = NodesControllerProvider._();

final class NodesControllerProvider
    extends $AsyncNotifierProvider<NodesController, List<NodeModel>> {
  const NodesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodesControllerHash();

  @$internal
  @override
  NodesController create() => NodesController();
}

String _$nodesControllerHash() => r'102bbe566a40c46d8d6978fa189c4cf9cdc14afe';

abstract class _$NodesController extends $AsyncNotifier<List<NodeModel>> {
  FutureOr<List<NodeModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<NodeModel>>, List<NodeModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<NodeModel>>, List<NodeModel>>,
              AsyncValue<List<NodeModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

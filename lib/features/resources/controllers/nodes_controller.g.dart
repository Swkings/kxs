// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nodes_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$nodesControllerHash() => r'dc3a4af1bc9f2be54c7f1f05df6ede2da75b5116';

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

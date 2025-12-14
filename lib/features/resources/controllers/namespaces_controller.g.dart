// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namespaces_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NamespacesController)
const namespacesControllerProvider = NamespacesControllerProvider._();

final class NamespacesControllerProvider
    extends $AsyncNotifierProvider<NamespacesController, List<NamespaceModel>> {
  const NamespacesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'namespacesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$namespacesControllerHash();

  @$internal
  @override
  NamespacesController create() => NamespacesController();
}

String _$namespacesControllerHash() =>
    r'96da2ffe6bbbb5a91a81c2c2e6f8bc3423ffe1b2';

abstract class _$NamespacesController
    extends $AsyncNotifier<List<NamespaceModel>> {
  FutureOr<List<NamespaceModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<NamespaceModel>>, List<NamespaceModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<NamespaceModel>>,
                List<NamespaceModel>
              >,
              AsyncValue<List<NamespaceModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SelectedNamespace)
const selectedNamespaceProvider = SelectedNamespaceProvider._();

final class SelectedNamespaceProvider
    extends $NotifierProvider<SelectedNamespace, String> {
  const SelectedNamespaceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedNamespaceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedNamespaceHash();

  @$internal
  @override
  SelectedNamespace create() => SelectedNamespace();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedNamespaceHash() => r'c14ed5a37d2cccb95a825fb1584d7dfe2bdc851f';

abstract class _$SelectedNamespace extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namespaces_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(namespacesRepository)
const namespacesRepositoryProvider = NamespacesRepositoryProvider._();

final class NamespacesRepositoryProvider
    extends
        $FunctionalProvider<
          NamespacesRepository,
          NamespacesRepository,
          NamespacesRepository
        >
    with $Provider<NamespacesRepository> {
  const NamespacesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'namespacesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$namespacesRepositoryHash();

  @$internal
  @override
  $ProviderElement<NamespacesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NamespacesRepository create(Ref ref) {
    return namespacesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NamespacesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NamespacesRepository>(value),
    );
  }
}

String _$namespacesRepositoryHash() =>
    r'80ffd08fff24ce72aed2051011c0cc41e7c05ad3';

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
    r'62032fb1ea846234adc42004a6433fe82f9edc9d';

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

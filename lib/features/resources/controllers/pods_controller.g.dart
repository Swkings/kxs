// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pods_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(podsRepository)
const podsRepositoryProvider = PodsRepositoryProvider._();

final class PodsRepositoryProvider
    extends $FunctionalProvider<PodsRepository, PodsRepository, PodsRepository>
    with $Provider<PodsRepository> {
  const PodsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PodsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PodsRepository create(Ref ref) {
    return podsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodsRepository>(value),
    );
  }
}

String _$podsRepositoryHash() => r'69fda15ab3daff4689926847e2a96fab47c0a57d';

@ProviderFor(PodsController)
const podsControllerProvider = PodsControllerFamily._();

final class PodsControllerProvider
    extends $AsyncNotifierProvider<PodsController, List<PodModel>> {
  const PodsControllerProvider._({
    required PodsControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'podsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$podsControllerHash();

  @override
  String toString() {
    return r'podsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PodsController create() => PodsController();

  @override
  bool operator ==(Object other) {
    return other is PodsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$podsControllerHash() => r'b9bd8f476eb6f61f584c21b4343f18e6255a0172';

final class PodsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PodsController,
          AsyncValue<List<PodModel>>,
          List<PodModel>,
          FutureOr<List<PodModel>>,
          String
        > {
  const PodsControllerFamily._()
    : super(
        retry: null,
        name: r'podsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PodsControllerProvider call(String namespace) =>
      PodsControllerProvider._(argument: namespace, from: this);

  @override
  String toString() => r'podsControllerProvider';
}

abstract class _$PodsController extends $AsyncNotifier<List<PodModel>> {
  late final _$args = ref.$arg as String;
  String get namespace => _$args;

  FutureOr<List<PodModel>> build(String namespace);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<List<PodModel>>, List<PodModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PodModel>>, List<PodModel>>,
              AsyncValue<List<PodModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

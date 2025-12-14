// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pods_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$podsControllerHash() => r'1b16912a208d2c2978a35b4fd6cf9d07e9dbe244';

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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pod_details_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(podDetailsRepository)
const podDetailsRepositoryProvider = PodDetailsRepositoryProvider._();

final class PodDetailsRepositoryProvider
    extends
        $FunctionalProvider<
          PodDetailsRepository,
          PodDetailsRepository,
          PodDetailsRepository
        >
    with $Provider<PodDetailsRepository> {
  const PodDetailsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podDetailsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podDetailsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PodDetailsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PodDetailsRepository create(Ref ref) {
    return podDetailsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodDetailsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodDetailsRepository>(value),
    );
  }
}

String _$podDetailsRepositoryHash() =>
    r'b45b45e306feca0de4eb9d8c2765f94d5b8a0076';

@ProviderFor(PodYamlController)
const podYamlControllerProvider = PodYamlControllerFamily._();

final class PodYamlControllerProvider
    extends $AsyncNotifierProvider<PodYamlController, String> {
  const PodYamlControllerProvider._({
    required PodYamlControllerFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'podYamlControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$podYamlControllerHash();

  @override
  String toString() {
    return r'podYamlControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PodYamlController create() => PodYamlController();

  @override
  bool operator ==(Object other) {
    return other is PodYamlControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$podYamlControllerHash() => r'cc6d321ca054b9615500a13900a9b8050d8d0e5b';

final class PodYamlControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PodYamlController,
          AsyncValue<String>,
          String,
          FutureOr<String>,
          (String, String)
        > {
  const PodYamlControllerFamily._()
    : super(
        retry: null,
        name: r'podYamlControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PodYamlControllerProvider call(String namespace, String name) =>
      PodYamlControllerProvider._(argument: (namespace, name), from: this);

  @override
  String toString() => r'podYamlControllerProvider';
}

abstract class _$PodYamlController extends $AsyncNotifier<String> {
  late final _$args = ref.$arg as (String, String);
  String get namespace => _$args.$1;
  String get name => _$args.$2;

  FutureOr<String> build(String namespace, String name);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(PodLogsController)
const podLogsControllerProvider = PodLogsControllerFamily._();

final class PodLogsControllerProvider
    extends $AsyncNotifierProvider<PodLogsController, String> {
  const PodLogsControllerProvider._({
    required PodLogsControllerFamily super.from,
    required (String, String, {String? container}) super.argument,
  }) : super(
         retry: null,
         name: r'podLogsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$podLogsControllerHash();

  @override
  String toString() {
    return r'podLogsControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PodLogsController create() => PodLogsController();

  @override
  bool operator ==(Object other) {
    return other is PodLogsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$podLogsControllerHash() => r'1af42a296500e4af937c905a760338931bb5dba5';

final class PodLogsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PodLogsController,
          AsyncValue<String>,
          String,
          FutureOr<String>,
          (String, String, {String? container})
        > {
  const PodLogsControllerFamily._()
    : super(
        retry: null,
        name: r'podLogsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PodLogsControllerProvider call(
    String namespace,
    String name, {
    String? container,
  }) => PodLogsControllerProvider._(
    argument: (namespace, name, container: container),
    from: this,
  );

  @override
  String toString() => r'podLogsControllerProvider';
}

abstract class _$PodLogsController extends $AsyncNotifier<String> {
  late final _$args = ref.$arg as (String, String, {String? container});
  String get namespace => _$args.$1;
  String get name => _$args.$2;
  String? get container => _$args.container;

  FutureOr<String> build(String namespace, String name, {String? container});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2, container: _$args.container);
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

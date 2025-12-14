// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pod_details_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$podYamlControllerHash() => r'a06c068da1f97b5ffabb51c3072c054a250b37af';

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

String _$podLogsControllerHash() => r'aae89cc1fc7f83ad395dcfb9cce47f584da94195';

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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiConfig)
const aiConfigProvider = AiConfigProvider._();

final class AiConfigProvider
    extends
        $NotifierProvider<
          AiConfig,
          ({String apiKey, String baseUrl, String provider})
        > {
  const AiConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiConfigHash();

  @$internal
  @override
  AiConfig create() => AiConfig();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    ({String apiKey, String baseUrl, String provider}) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            ({String apiKey, String baseUrl, String provider})
          >(value),
    );
  }
}

String _$aiConfigHash() => r'99d0c0034434e164345ba6b50230e87cf254dce0';

abstract class _$AiConfig
    extends $Notifier<({String apiKey, String baseUrl, String provider})> {
  ({String apiKey, String baseUrl, String provider}) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              ({String apiKey, String baseUrl, String provider}),
              ({String apiKey, String baseUrl, String provider})
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({String apiKey, String baseUrl, String provider}),
                ({String apiKey, String baseUrl, String provider})
              >,
              ({String apiKey, String baseUrl, String provider}),
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(aiService)
const aiServiceProvider = AiServiceProvider._();

final class AiServiceProvider
    extends $FunctionalProvider<AIService, AIService, AIService>
    with $Provider<AIService> {
  const AiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiServiceHash();

  @$internal
  @override
  $ProviderElement<AIService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AIService create(Ref ref) {
    return aiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AIService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AIService>(value),
    );
  }
}

String _$aiServiceHash() => r'bd59e1e34b4c5b9c588cb5f728f721f4382ff703';

@ProviderFor(LogAnalysis)
const logAnalysisProvider = LogAnalysisProvider._();

final class LogAnalysisProvider
    extends $AsyncNotifierProvider<LogAnalysis, String> {
  const LogAnalysisProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logAnalysisProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logAnalysisHash();

  @$internal
  @override
  LogAnalysis create() => LogAnalysis();
}

String _$logAnalysisHash() => r'b74f310a5cebd4419fb0f366243dc50d9ad5f256';

abstract class _$LogAnalysis extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
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

@ProviderFor(YamlOptimization)
const yamlOptimizationProvider = YamlOptimizationProvider._();

final class YamlOptimizationProvider
    extends $AsyncNotifierProvider<YamlOptimization, String> {
  const YamlOptimizationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'yamlOptimizationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$yamlOptimizationHash();

  @$internal
  @override
  YamlOptimization create() => YamlOptimization();
}

String _$yamlOptimizationHash() => r'8e51fb73abc25d21d294efa71c12f48ec1a8af5a';

abstract class _$YamlOptimization extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
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

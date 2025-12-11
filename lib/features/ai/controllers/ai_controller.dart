import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/core/services/ai_service.dart';
import 'package:kxs/core/services/openai_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_controller.g.dart';

@riverpod
class AiConfig extends _$AiConfig {
  @override
  ({String apiKey, String provider, String baseUrl}) build() {
    // In a real app, load this from shared_preferences or secure_storage
    return (apiKey: '', provider: 'openai', baseUrl: 'https://api.openai.com/v1');
  }

  void setApiKey(String key) {
    state = (apiKey: key, provider: state.provider, baseUrl: state.baseUrl);
  }

  void setBaseUrl(String url) {
    state = (apiKey: state.apiKey, provider: state.provider, baseUrl: url);
  }
}

@riverpod
AIService aiService(Ref ref) {
  final config = ref.watch(aiConfigProvider);
  // Default to dummy/mock if no key? Or just let it return error string.
  return OpenAIService(apiKey: config.apiKey, baseUrl: config.baseUrl);
}

@riverpod
class LogAnalysis extends _$LogAnalysis {
  @override
  FutureOr<String> build() async {
    // Only analyze if explicitly requested to avoid burning tokens on every build?
    // Actually, this provider is 'build(logs)', so it will run when watched with new logs.
    // We probably want a Notifier that triggers on user action, not auto-run.
    // So let's return empty initially or handle it via a method.
    return ''; 
  }

  Future<void> analyze(String logs) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(aiServiceProvider);
      return service.analyzeLogs(logs);
    });
  }
}

@riverpod
class YamlOptimization extends _$YamlOptimization {
  @override
  FutureOr<String> build() async {
    return '';
  }

  Future<void> optimize(String yaml) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(aiServiceProvider);
      return service.optimizeYaml(yaml);
    });
  }
}

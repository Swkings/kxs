abstract class AIService {
  /// Analyzes a block of logs to find errors and suggest fixes.
  Future<String> analyzeLogs(String logs);

  /// Suggests optimizations or fixes for a K8s YAML resource.
  Future<String> optimizeYaml(String yaml);

  /// General query method for chat-like interactions.
  Future<String> chat(String message, {String? systemContext});
}

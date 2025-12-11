import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kxs/core/services/ai_service.dart';

class OpenAIService implements AIService {
  final String apiKey;
  final String baseUrl;
  final String model;

  OpenAIService({
    required this.apiKey,
    this.baseUrl = 'https://api.openai.com/v1',
    this.model = 'gpt-4o',
  });

  @override
  Future<String> analyzeLogs(String logs) async {
    return _completion(
      systemPrompt: 'You are an expert Kubernetes administrator. Analyze the following logs for errors and suggest potential root causes and fixes. Be concise.',
      userMessage: logs,
    );
  }

  @override
  Future<String> optimizeYaml(String yaml) async {
    return _completion(
      systemPrompt: 'You are an expert Kubernetes administrator. Review the following YAML for best practices, security improvements, and resource optimizations. Output ONLY the improved YAML or a concise list of suggestions.',
      userMessage: yaml,
    );
  }

  @override
  Future<String> chat(String message, {String? systemContext}) async {
     return _completion(
      systemPrompt: systemContext ?? 'You are a helpful Kubernetes assistant.',
      userMessage: message,
    );
  }

  Future<String> _completion({required String systemPrompt, required String userMessage}) async {
    if (apiKey.isEmpty) {
      return 'Error: AI API Key is not set. Please configure it in settings.';
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userMessage},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'].toString();
      } else {
        return 'AI Request Failed: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'AI Request Error: $e';
    }
  }
}

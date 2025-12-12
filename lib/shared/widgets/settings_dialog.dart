import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

enum SettingsTab {
  general,
  aiModel,
  dataBackup,
  deviceBinding,
  feedback,
  disclaimer,
}

enum AIProvider {
  gemini,
  openai,
  deepseek,
  qwen,
  doubao,
  volcano,
  ollama,
}

class SettingsDialog extends ConsumerStatefulWidget {
  const SettingsDialog({super.key});

  @override
  ConsumerState<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends ConsumerState<SettingsDialog> {
  AIProvider _selectedMainModel = AIProvider.gemini;
  
  // AI Provider states
  final Map<AIProvider, bool> _providerEnabled = {
    AIProvider.gemini: true,
    AIProvider.openai: false,
    AIProvider.deepseek: false,
    AIProvider.qwen: false,
    AIProvider.doubao: false,
    AIProvider.volcano: false,
    AIProvider.ollama: true,
  };
  
  // Expanded states for AI providers
  final Map<AIProvider, bool> _providerExpanded = {
    AIProvider.gemini: false,
    AIProvider.openai: false,
    AIProvider.deepseek: false,
    AIProvider.qwen: false,
    AIProvider.doubao: false,
    AIProvider.volcano: false,
    AIProvider.ollama: true,
  };
  
  // API Keys
  final Map<AIProvider, TextEditingController> _apiKeyControllers = {
    AIProvider.gemini: TextEditingController(),
    AIProvider.openai: TextEditingController(),
    AIProvider.deepseek: TextEditingController(),
    AIProvider.qwen: TextEditingController(),
    AIProvider.doubao: TextEditingController(),
    AIProvider.volcano: TextEditingController(),
    AIProvider.ollama: TextEditingController(),
  };
  
  // Base URLs
  final Map<AIProvider, TextEditingController> _baseUrlControllers = {
    AIProvider.gemini: TextEditingController(),
    AIProvider.openai: TextEditingController(),
    AIProvider.deepseek: TextEditingController(),
    AIProvider.qwen: TextEditingController(),
    AIProvider.doubao: TextEditingController(),
    AIProvider.volcano: TextEditingController(),
    AIProvider.ollama: TextEditingController(text: 'http://localhost:11434/v1'),
  };
  
  // Text models
  final Map<AIProvider, List<String>> _textModels = {
    AIProvider.gemini: ['gemini-2.5-flash'],
    AIProvider.openai: [],
    AIProvider.deepseek: [],
    AIProvider.qwen: [],
    AIProvider.doubao: [],
    AIProvider.volcano: [],
    AIProvider.ollama: ['gemma:latest'],
  };

  @override
  void dispose() {
    for (var controller in _apiKeyControllers.values) {
      controller.dispose();
    }
    for (var controller in _baseUrlControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 900,
        height: 700,
        decoration: BoxDecoration(
          color: const Color(0xFF1a1d2e),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Content
            Expanded(
              child: _buildAIModelSettings(),
            ),
            
            // Footer buttons
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.settings, size: 24),
          const SizedBox(width: 12),
          const Text(
            '系统设置',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildAIModelSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI 配置',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Main model selector
          Row(
            children: [
              const Text('主模型:', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AIProvider>(
                    value: _selectedMainModel,
                    dropdownColor: const Color(0xFF1a1d2e),
                    items: AIProvider.values.map((provider) {
                      return DropdownMenuItem(
                        value: provider,
                        child: Text(
                          provider.name.toUpperCase(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedMainModel = value);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '用于生成的主要 AI。如果失败，系统将自动尝试启用的备用模型。',
            style: TextStyle(fontSize: 12, color: Colors.blue.shade300),
          ),
          const SizedBox(height: 32),
          
          // AI Provider panels
          ...AIProvider.values.map((provider) => _buildProviderPanel(provider)),
        ],
      ),
    );
  }

  Widget _buildProviderPanel(AIProvider provider) {
    final isExpanded = _providerExpanded[provider]!;
    final isEnabled = _providerEnabled[provider]!;
    final providerName = provider.name.toUpperCase();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnabled
              ? (provider == AIProvider.gemini ? Colors.green : Colors.blue).withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _providerExpanded[provider] = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isEnabled ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    providerName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: isEnabled,
                    onChanged: (value) {
                      setState(() {
                        _providerEnabled[provider] = value;
                      });
                    },
                    thumbColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.blue;
                        }
                        return Colors.grey;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content (only show when expanded and enabled)
          if (isExpanded && isEnabled) ...[
            const Divider(height: 1, color: Colors.white12),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // API KEY
                  const Text('API KEY', style: TextStyle(fontSize: 12, color: Colors.white60)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _apiKeyControllers[provider],
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      suffixIcon: const Icon(Icons.visibility, size: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // BASE URL (optional for some providers)
                  if (_shouldShowBaseUrl(provider)) ...[
                    Row(
                      children: [
                        const Text('BASE URL (可选)', style: TextStyle(fontSize: 12, color: Colors.white60)),
                        const Spacer(),
                        if (provider == AIProvider.ollama)
                          TextButton(
                            onPressed: () async {
                              final baseUrl = _baseUrlControllers[provider]!.text;
                              if (baseUrl.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('请先设置 BASE URL'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }
                              
                              try {
                                // Remove /v1 suffix if present for tags endpoint
                                final apiUrl = baseUrl.replaceAll('/v1', '');
                                final response = await http.get(
                                  Uri.parse('$apiUrl/api/tags'),
                                );
                                
                                if (response.statusCode == 200) {
                                  final data = json.decode(response.body);
                                  final models = data['models'] as List;
                                  
                                  setState(() {
                                    _textModels[provider]!.clear();
                                    for (final model in models) {
                                      final modelName = model['name'] as String;
                                      _textModels[provider]!.add(modelName);
                                    }
                                  });
                                  
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('成功获取 ${models.length} 个模型'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  throw Exception('HTTP ${response.statusCode}');
                                }
                              } on Exception catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('获取模型失败: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                            ),
                            child: const Text('获取默认列表', style: TextStyle(fontSize: 12)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _baseUrlControllers[provider],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                      ),
                    ),
                    if (provider == AIProvider.ollama) ...[
                      const SizedBox(height: 8),
                      Text(
                        '对于本地 Ollama，通常为 http://localhost:11434/v1',
                        style: TextStyle(fontSize: 11, color: Colors.blue.shade300),
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                  
                  // Text models
                  _buildModelSection(provider, '文本模型 (对话)', true),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModelSection(AIProvider provider, String title, bool isText) {
    final models = _textModels[provider]!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.white60)),
        const SizedBox(height: 8),
        
        // Model chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: models.asMap().entries.map((entry) {
            final index = entry.key;
            final model = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: provider == AIProvider.gemini
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: provider == AIProvider.gemini
                      ? Colors.green.withValues(alpha: 0.5)
                      : Colors.blue.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${index + 1}. $model', style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 8),
                  const Icon(Icons.play_arrow, size: 14),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      setState(() {
                        models.removeAt(index);
                      });
                    },
                    child: const Icon(Icons.close, size: 14),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        
        // Add model input
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '输入新模型 ID...',
                  hintStyle: TextStyle(fontSize: 12, color: Colors.white30),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      models.add(value);
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text('添加', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ],
    );
  }

  bool _shouldShowBaseUrl(AIProvider provider) {
    // Show BASE URL for providers that support custom endpoints
    return provider == AIProvider.ollama || 
           provider == AIProvider.openai ||
           provider == AIProvider.deepseek;
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              // Save settings
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}

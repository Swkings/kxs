import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kxs/features/settings/providers/settings_provider.dart';
import 'package:kxs/features/terminal/controllers/terminal_controller.dart';

enum SettingsTab {
  general,
  aiModel,
  dataBackup,
  terminal,
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
  SettingsTab _selectedTab = SettingsTab.general;
  AIProvider _selectedMainModel = AIProvider.gemini;
  
  final Map<AIProvider, bool> _providerEnabled = {
    AIProvider.gemini: true,
    AIProvider.openai: false,
    AIProvider.deepseek: false,
    AIProvider.qwen: false,
    AIProvider.doubao: false,
    AIProvider.volcano: false,
    AIProvider.ollama: true,
  };
  
  final Map<AIProvider, bool> _providerExpanded = {
    AIProvider.gemini: false,
    AIProvider.openai: false,
    AIProvider.deepseek: false,
    AIProvider.qwen: false,
    AIProvider.doubao: false,
    AIProvider.volcano: false,
    AIProvider.ollama: true,
  };
  
  final Map<AIProvider, TextEditingController> _apiKeyControllers = {
    AIProvider.gemini: TextEditingController(),
    AIProvider.openai: TextEditingController(),
    AIProvider.deepseek: TextEditingController(),
    AIProvider.qwen: TextEditingController(),
    AIProvider.doubao: TextEditingController(),
    AIProvider.volcano: TextEditingController(),
    AIProvider.ollama: TextEditingController(),
  };
  
  final Map<AIProvider, TextEditingController> _baseUrlControllers = {
    AIProvider.gemini: TextEditingController(),
    AIProvider.openai: TextEditingController(),
    AIProvider.deepseek: TextEditingController(),
    AIProvider.qwen: TextEditingController(),
    AIProvider.doubao: TextEditingController(),
    AIProvider.volcano: TextEditingController(),
    AIProvider.ollama: TextEditingController(text: 'http://localhost:11434/v1'),
  };
  
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
            _buildHeader(),
            Expanded(
              child: Row(
                children: [
                   _buildSidebar(),
                   const VerticalDivider(width: 1, color: Colors.white12),
                   Expanded(child: _buildContent()),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          _buildSidebarItem(SettingsTab.general, '常规设置', Icons.settings),
          _buildSidebarItem(SettingsTab.aiModel, 'AI 模型', Icons.psychology),
          _buildSidebarItem(SettingsTab.terminal, '终端设置', Icons.terminal),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(SettingsTab tab, String label, IconData icon) {
    final isSelected = _selectedTab == tab;
    return InkWell(
      onTap: () => setState(() => _selectedTab = tab),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: isSelected ? Colors.white.withValues(alpha: 0.05) : null,
        child: Row(
          children: [
            Icon(icon, size: 20, color: isSelected ? Colors.blue : Colors.white60),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.white60,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return switch (_selectedTab) {
      SettingsTab.general => _buildGeneralSettings(),
      SettingsTab.aiModel => _buildAIModelSettings(),
      SettingsTab.terminal => _buildTerminalSettings(),
      _ => const Center(child: Text('Coming Soon')),
    };
  }

  Widget _buildTerminalSettings() {
    final settings = ref.watch(terminalSettingsControllerProvider);
    final notifier = ref.read(terminalSettingsControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('终端配置', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          
          const Text('Shell 路径', style: TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 8),
          FutureBuilder<List<String>>(
            future: notifier.getAvailableShells(),
            builder: (context, snapshot) {
              final shells = snapshot.data ?? [settings.shellPath];
              if (!shells.contains(settings.shellPath)) {
                shells.add(settings.shellPath);
              }
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: settings.shellPath,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1a1d2e),
                    items: shells.map((path) => DropdownMenuItem(
                      value: path,
                      child: Text(path),
                    )).toList(),
                    onChanged: (val) {
                      if (val != null) notifier.updateShellPath(val);
                    },
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 16),
          const Text('手动指定路径', style: TextStyle(fontSize: 12, color: Colors.white54)),
          const SizedBox(height: 4),
          TextField(
            controller: TextEditingController(text: settings.shellPath),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onSubmitted: (val) {
              if (val.isNotEmpty) notifier.updateShellPath(val);
            },
          ),

          const SizedBox(height: 32),
          const Text('字体大小', style: TextStyle(fontSize: 14, color: Colors.white70)),
          Slider(
            value: settings.fontSize,
            min: 10,
            max: 30,
            divisions: 20,
            label: settings.fontSize.round().toString(),
            onChanged: (val) => notifier.updateFontSize(val),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings() {
    final useKubectl = ref.watch(settingsProvider);
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kubernetes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('使用 Kubectl CLI'),
            subtitle: const Text('启用此选项以直接使用本地 kubectl 命令管理集群 (备用方案)。默认使用 API Client。'),
            value: useKubectl,
            onChanged: (val) {
               ref.read(settingsProvider.notifier).setUseKubectl(val);
            },
            activeColor: Colors.blue,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide.none, bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          const Icon(Icons.settings, size: 24),
          const SizedBox(width: 12),
          const Text(
            '系统设置',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          const Text('AI 配置', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
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
                        child: Text(provider.name.toUpperCase(), style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedMainModel = value);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('用于生成的主要 AI。', style: TextStyle(fontSize: 12, color: Colors.blue.shade300)),
          const SizedBox(height: 32),
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
          InkWell(
            onTap: () => setState(() => _providerExpanded[provider] = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(color: isEnabled ? Colors.green : Colors.grey, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 12),
                  Text(providerName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Switch(
                    value: isEnabled,
                    onChanged: (value) => setState(() => _providerEnabled[provider] = value),
                    thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) => states.contains(WidgetState.selected) ? Colors.blue : Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded && isEnabled) ...[
            const Divider(height: 1, color: Colors.white12),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('API KEY', style: TextStyle(fontSize: 12, color: Colors.white60)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _apiKeyControllers[provider],
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: const Icon(Icons.visibility, size: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_shouldShowBaseUrl(provider)) ...[
                    const Text('BASE URL (可选)', style: TextStyle(fontSize: 12, color: Colors.white60)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _baseUrlControllers[provider],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                  _buildModelSection(provider, '文本模型 (对话)', true),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  bool _shouldShowBaseUrl(AIProvider provider) {
    return provider == AIProvider.ollama || provider == AIProvider.openai || provider == AIProvider.deepseek;
  }

  Widget _buildModelSection(AIProvider provider, String title, bool isText) {
    final models = _textModels[provider]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.white60)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: models.asMap().entries.map((entry) {
            final index = entry.key;
            final model = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${index + 1}. $model', style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => setState(() => models.removeAt(index)),
                    child: const Icon(Icons.close, size: 14),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('关闭')),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}

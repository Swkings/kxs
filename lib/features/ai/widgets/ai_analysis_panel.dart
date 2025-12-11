import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:kxs/features/ai/controllers/ai_controller.dart';
import 'package:kxs/l10n/app_localizations.dart';

class AiAnalysisPanel extends ConsumerWidget {
  final String title;
  final IconData icon;
  final String actionLabel;
  final AsyncValue<String> analysisState;
  final VoidCallback onAnalyze;
  final bool showConfigIfNotSet;

  const AiAnalysisPanel({
    super.key,
    required this.title,
    required this.icon,
    required this.actionLabel,
    required this.analysisState,
    required this.onAnalyze,
    this.showConfigIfNotSet = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiConfig = ref.watch(aiConfigProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.purpleAccent, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent)),
              const Spacer(),
              if (showConfigIfNotSet && aiConfig.apiKey.isEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.settings, size: 16),
                  label: Text(AppLocalizations.of(context)!.btnConfigApiKey),
                  onPressed: () => _showApiKeyDialog(context, ref),
                )
              else if (analysisState is! AsyncLoading)
                ElevatedButton.icon(
                  icon: Icon(icon, size: 16),
                  label: Text(actionLabel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent.withValues(alpha: 0.2),
                  ),
                  onPressed: onAnalyze,
                ),
            ],
          ),
          if (analysisState is AsyncLoading)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: LinearProgressIndicator(color: Colors.purpleAccent),
            ),
          if (analysisState is AsyncData && analysisState.value != null && analysisState.value!.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
              ),
              child: SingleChildScrollView(
                child: MarkdownBody(data: analysisState.value!),
              ),
            ),
        ],
      ),
    );
  }

  void _showApiKeyDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: ref.read(aiConfigProvider).apiKey);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.dialogConfigOpenAi),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.labelApiKey,
                hintText: 'sk-...',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.aiProviderComingSoon, style: const TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.btnCancel)),
          TextButton(
            onPressed: () {
              ref.read(aiConfigProvider.notifier).setApiKey(controller.text);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.btnSave),
          ),
        ],
      ),
    );
  }
}

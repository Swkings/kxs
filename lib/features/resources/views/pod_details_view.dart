import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/features/resources/controllers/pod_details_controller.dart';
import 'package:kxs/features/resources/controllers/pods_controller.dart';
import 'package:kxs/features/ai/controllers/ai_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kxs/l10n/app_localizations.dart';
import 'package:kxs/features/ai/widgets/ai_analysis_panel.dart';

class PodDetailsView extends ConsumerStatefulWidget {
  final String namespace;
  final String podName;
  final int initialTab;

  const PodDetailsView({
    super.key,
    required this.namespace,
    required this.podName,
    this.initialTab = 0,
  });

  @override
  ConsumerState<PodDetailsView> createState() => _PodDetailsViewState();
}

class _PodDetailsViewState extends ConsumerState<PodDetailsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: 800,
        height: 600,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color?.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              spreadRadius: 5,
            )
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white12)),
              ),
              child: Row(
                children: [
                   Text(widget.podName, style: Theme.of(context).textTheme.titleLarge),
                   const SizedBox(width: 8),
                   Text('(${widget.namespace})', style: const TextStyle(color: Colors.white54)),
                   const Spacer(),
                   IconButton(
                     icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                     tooltip: 'Delete Pod',
                     onPressed: _confirmDelete,
                   ),
                   const SizedBox(width: 8),
                   IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            // Tabs
            TabBar(
              controller: _tabController,
              tabs: [Tab(text: AppLocalizations.of(context)!.podDetailsYaml), Tab(text: AppLocalizations.of(context)!.podDetailsLogs)],
              indicatorColor: Theme.of(context).primaryColor,
            ),
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildYamlView(),
                  _buildLogsView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYamlView() {
    final yamlAsync = ref.watch(podYamlControllerProvider(widget.namespace, widget.podName));
    return yamlAsync.when(
      data: (yaml) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                yaml,
                style: GoogleFonts.firaCode(fontSize: 13, color: Colors.white70),
              ),
            ),
          ),
          _buildAiYamlPanel(yaml),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
    );
  }

  Widget _buildAiYamlPanel(String yaml) {
      final optimizationAsync = ref.watch(yamlOptimizationProvider);
      return AiAnalysisPanel(
          title: AppLocalizations.of(context)!.aiOptimizationTitle,
          icon: Icons.build,
          actionLabel: AppLocalizations.of(context)!.btnOptimizeYaml,
          analysisState: optimizationAsync,
          onAnalyze: () {
              ref.read(yamlOptimizationProvider.notifier).optimize(yaml);
          },
      );
  }

  Widget _buildLogsView() {
    final logsAsync = ref.watch(podLogsControllerProvider(widget.namespace, widget.podName));
    // We watch the logic for analysis. Since it's a family/argument based notifier in my planned controller?
    // Actually the controller I made `LogAnalysis` is family-less but takes args in method.
    // I should probably use a provider that holds the analysis result.
    // Let's assume I use a local state or a simplified provider for this view.
    // Ideally: `ref.watch(logAnalysisProvider(logs))` but we want to trigger it manually.
    
    return logsAsync.when(
      data: (logs) => Column(
        children: [
            Expanded(
                child: Container(
                color: Colors.black45,
                child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                    logs,
                    style: GoogleFonts.firaCode(fontSize: 12, color: Colors.greenAccent),
                ),
                ),
            ),
            ),
            _buildAiAnalysisPanel(logs),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
    );
  }

  Widget _buildAiAnalysisPanel(String logs) {
      final analysisAsync = ref.watch(logAnalysisProvider);
      return AiAnalysisPanel(
          title: AppLocalizations.of(context)!.aiAnalysisTitle,
          icon: Icons.analytics,
          actionLabel: AppLocalizations.of(context)!.btnAnalyzeLogs,
          analysisState: analysisAsync,
          onAnalyze: () {
               // Truncate logs if too long to save tokens
               final truncatedLogs = logs.length > 5000 ? logs.substring(logs.length - 5000) : logs;
               ref.read(logAnalysisProvider.notifier).analyze(truncatedLogs);
          },
      );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pod?'),
        content: Text('Are you sure you want to delete ${widget.podName}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.btnCancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            onPressed: () {
               ref.read(podsControllerProvider(widget.namespace).notifier).deletePod(widget.podName);
               Navigator.pop(context); // Close confirm
               Navigator.pop(context); // Close details
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

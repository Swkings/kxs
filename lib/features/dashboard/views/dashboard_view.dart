import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/features/cluster/views/cluster_selector_view.dart';
import 'package:kxs/features/dashboard/controllers/dashboard_controller.dart';
import 'package:kxs/features/resources/views/pods_view.dart';
import 'package:kxs/features/resources/views/nodes_view.dart';
import 'package:kxs/features/resources/views/services_view.dart';
import 'package:kxs/features/resources/views/namespace_selector_view.dart';
import 'package:kxs/features/resources/controllers/namespaces_controller.dart';
import 'package:kxs/l10n/app_localizations.dart';
import 'package:kxs/shared/widgets/command_palette_overlay.dart';
import 'package:kxs/shared/widgets/command_palette_provider.dart';
import 'package:kxs/shared/widgets/keyboard_help_overlay.dart';
import 'package:kxs/shared/widgets/global_app_bar.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  bool _showHelpOverlay = false;

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(dashboardControllerProvider);
    final commandPaletteVisible = ref.watch(commandPaletteVisibleProvider);

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          // Ctrl+Q to go back to home
          if (event.logicalKey == LogicalKeyboardKey.keyQ && 
              HardwareKeyboard.instance.isControlPressed) {
            Navigator.of(context).pop();
          }
          // : (colon) to open command palette
          else if (event.character == ':') {
            ref.read(commandPaletteVisibleProvider.notifier).show();
          }
          // ? (question mark) to show help
          else if (event.character == '?') {
            setState(() => _showHelpOverlay = !_showHelpOverlay);
          }
          // Esc to close command palette or help
          else if (event.logicalKey == LogicalKeyboardKey.escape) {
            if (commandPaletteVisible) {
              ref.read(commandPaletteVisibleProvider.notifier).hide();
            } else if (_showHelpOverlay) {
              setState(() => _showHelpOverlay = false);
            }
          }
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: const GlobalAppBar(),  // Removed showBackButton parameter
            body: Row(
              children: [
                // Sidebar - fully scrollable to prevent overflow
                Container(
                  width: 250,
                  color: Theme.of(context).cardTheme.color,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    children: [
                      // Home button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.home, size: 18),
                          label: const Text('返回主页'),
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      // Cluster selector
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: ClusterSelectorView(),
                      ),
                      const SizedBox(height: 8),
                      // Namespace selector
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: NamespaceSelectorView(),
                      ),
                      const SizedBox(height: 24),
                      // Navigation items
                      _buildNavItem(context, Icons.dashboard_rounded, AppLocalizations.of(context)!.navOverview, DashboardTab.overview, currentTab),
                      _buildNavItem(context, Icons.storage_rounded, AppLocalizations.of(context)!.navPods, DashboardTab.pods, currentTab),
                      _buildNavItem(context, Icons.dns_rounded, AppLocalizations.of(context)!.navServices, DashboardTab.services, currentTab),
                      _buildNavItem(context, Icons.computer_rounded, AppLocalizations.of(context)!.navNodes, DashboardTab.nodes, currentTab),
                    ],
                  ),
                ),
                // Main Content
                Expanded(
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: _buildContent(context, ref, currentTab),
                  ),
                ),
              ],
            ),
          ),
          
          // Command Palette Overlay
          if (commandPaletteVisible)
            const CommandPaletteOverlay(),
          
          // Help Overlay
          if (_showHelpOverlay)
            KeyboardHelpOverlay(
              onClose: () => setState(() => _showHelpOverlay = false),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, DashboardTab tab) {
    switch (tab) {
      case DashboardTab.pods:
        final selectedNs = ref.watch(selectedNamespaceProvider);
        return PodsView(namespace: selectedNs);
      case DashboardTab.nodes:
        return const NodesView();
      case DashboardTab.services:
        final selectedNs = ref.watch(selectedNamespaceProvider);
        return ServicesView(namespace: selectedNs);
      case DashboardTab.overview:
        return Center(child: Text(AppLocalizations.of(context)!.dashboardClusterOverview));
    }
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, DashboardTab tab, DashboardTab currentTab) {
    final isSelected = tab == currentTab;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected 
          ? Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)) 
          : Border.all(color: Colors.transparent),
      ),
      child: ListTile(
        leading: Icon(
          icon, 
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white60,
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          ref.read(dashboardControllerProvider.notifier).setTab(tab);
        },
      ),
    );
  }
}

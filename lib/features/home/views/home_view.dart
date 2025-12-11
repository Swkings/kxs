import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/shared/models/kubeconfig_model.dart';
import 'package:kxs/shared/widgets/kubeconfig_card.dart';
import 'package:kxs/shared/widgets/import_kubeconfig_card.dart';
import 'package:kxs/l10n/app_localizations.dart';
import 'package:kxs/features/dashboard/views/dashboard_view.dart';
import 'package:kxs/core/theme/theme_mode.dart';
import 'package:kxs/core/theme/theme_provider.dart';
import 'package:kxs/shared/widgets/settings_dialog.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  // Mock kubeconfig data - in real app, load from ~/.kube/config
  final List<KubeconfigModel> _kubeconfigs = [
    const KubeconfigModel(
      name: 'Development Cluster',
      context: 'dev-context',
      cluster: 'dev.k8s.local',
      user: 'dev-admin',
      namespace: 'default',
    ),
    const KubeconfigModel(
      name: 'Production Cluster',
      context: 'prod-context',
      cluster: 'prod.k8s.local',
      user: 'prod-admin',
      namespace: 'kube-system',
    ),
    const KubeconfigModel(
      name: 'Staging Cluster',
      context: 'staging-context',
      cluster: 'staging.k8s.local',
      user: 'staging-admin',
    ),
    const KubeconfigModel(
      name: 'Invalid Cluster',
      context: 'invalid-context',
      cluster: 'invalid.k8s.local',
      isValid: false,
      errorMessage: 'Failed to connect: context not found in kubeconfig',
    ),
  ];

  int? _selectedIndex;

  void _connectToCluster(int index) {
    final config = _kubeconfigs[index];
    
    // Don't navigate if config is invalid
    if (!config.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(config.errorMessage ?? 'Invalid configuration'),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }
    
    setState(() {
      _selectedIndex = index;
    });
    
    // Navigate to dashboard
    Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const DashboardView()),
    );
  }

  void _importKubeconfig() {
    // TODO: Implement file picker - use file_picker package
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['yaml', 'yml', 'config'],
    // );
    // if (result != null) {
    //   // Parse kubeconfig and add to list
    // }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.importFromFile),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _editKubeconfig(int index) {
    final config = _kubeconfigs[index];
    final l10n = AppLocalizations.of(context)!;
    
    final nameController = TextEditingController(text: config.name);
    final contextController = TextEditingController(text: config.context);
    final clusterController = TextEditingController(text: config.cluster);
    final userController = TextEditingController(text: config.user ?? '');
    final namespaceController = TextEditingController(text: config.namespace ?? 'default');
    
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editKubeconfig),
        content: SizedBox(
          width: 450,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.kubeconfigName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contextController,
                  decoration: InputDecoration(
                    labelText: l10n.kubeconfigContext,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: clusterController,
                  decoration: InputDecoration(
                    labelText: l10n.kubeconfigCluster,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: userController,
                  decoration: InputDecoration(
                    labelText: l10n.kubeconfigUser,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: namespaceController,
                  decoration: InputDecoration(
                    labelText: l10n.kubeconfigNamespace,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _kubeconfigs[index] = config.copyWith(
                  name: nameController.text,
                  context: contextController.text,
                  cluster: clusterController.text,
                  user: userController.text.isEmpty ? null : userController.text,
                  namespace: namespaceController.text.isEmpty ? null : namespaceController.text,
                );
              });
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _deleteKubeconfig(int index) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _kubeconfigs.removeAt(index);
                if (_selectedIndex == index) {
                  _selectedIndex = null;
                } else if (_selectedIndex != null && _selectedIndex! > index) {
                  _selectedIndex = _selectedIndex! - 1;
                }
              });
              Navigator.pop(context);
            },
            child: Text(l10n.deleteKubeconfig),
          ),
        ],
      ),
    );
  }

  void _copyKubeconfig(int index) {
    final config = _kubeconfigs[index];
    setState(() {
      _kubeconfigs.add(config.copyWith(
        name: '${config.name} (Copy)',
      ));
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${config.name} copied'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        actions: [
          _buildLanguageMenu(context),
          const SizedBox(width: 8),
          _buildThemeMenu(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: _showSettings,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.appTitle,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.dashboardSubtitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _kubeconfigs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.cloud_off,
                              size: 64,
                              color: Colors.white24,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noKubeconfigs,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          childAspectRatio: 1.3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _kubeconfigs.length + 1, // +1 for import card
                        itemBuilder: (context, index) {
                          // Last card is always the import card
                          if (index == _kubeconfigs.length) {
                            return ImportKubeconfigCard(
                              onTap: _importKubeconfig,
                            );
                          }
                          
                          // All other cards are configs
                          final config = _kubeconfigs[index].copyWith(
                            isActive: _selectedIndex == index,
                          );
                          return Draggable<int>(
                            data: index,
                            feedback: Material(
                              elevation: 8,
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 350,
                                child: Opacity(
                                  opacity: 0.8,
                                  child: KubeconfigCard(
                                    config: config,
                                    onTap: () {},
                                  ),
                                ),
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.3,
                              child: KubeconfigCard(
                                config: config,
                                onTap: () {},
                              ),
                            ),
                            child: DragTarget<int>(
                              onAcceptWithDetails: (details) {
                                setState(() {
                                  final draggedItem = _kubeconfigs.removeAt(details.data);
                                  _kubeconfigs.insert(index, draggedItem);
                                });
                              },
                              builder: (context, candidateData, rejectedData) {
                                return KubeconfigCard(
                                  config: config,
                                  onTap: () => _connectToCluster(index),
                                  onEdit: () => _editKubeconfig(index),
                                  onDelete: () => _deleteKubeconfig(index),
                                  onCopy: () => _copyKubeconfig(index),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettings() {
    showDialog<void>(
      context: context,
      builder: (context) => const SettingsDialog(),
    );
  }

  Widget _buildLanguageMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: l10n.language,
      onSelected: (Locale locale) {
        // In a real app, use a provider to manage locale
        // For now, this is just UI demonstration
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Text(l10n.languageEnglish),
        ),
        PopupMenuItem(
          value: const Locale('zh'),
          child: Text(l10n.languageChinese),
        ),
      ],
    );
  }

  Widget _buildThemeMenu() {
    final currentTheme = ref.watch(themeControllerProvider);
    
    return PopupMenuButton<AppThemeMode>(
      icon: Icon(currentTheme.icon),
      tooltip: 'Theme',
      onSelected: (AppThemeMode mode) {
        ref.read(themeControllerProvider.notifier).setTheme(mode);
      },
      itemBuilder: (context) => AppThemeMode.values.map((mode) {
        return PopupMenuItem(
          value: mode,
          child: Row(
            children: [
              Icon(mode.icon, size: 20),
              const SizedBox(width: 12),
              Text(mode.displayName),
              if (mode == currentTheme) ...[
                const Spacer(),
                Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

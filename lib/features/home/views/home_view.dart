import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kxs/shared/models/kubeconfig_model.dart';
import 'package:kxs/shared/widgets/kubeconfig_card.dart';
import 'package:kxs/shared/widgets/import_kubeconfig_card.dart';
import 'package:kxs/l10n/app_localizations.dart';
import 'package:kxs/features/dashboard/views/dashboard_view.dart';
import 'package:kxs/shared/widgets/global_app_bar.dart';
import 'package:kxs/shared/widgets/yaml_editor_dialog.dart';

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

  Future<bool> _validateConnection(KubeconfigModel config) async {
    // Simulate connection validation
    // In real implementation, this would try to connect to the k8s cluster
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Return whether config is valid
    // In real implementation, this would test actual connectivity
    return config.isValid;
  }

  Future<void> _connectToCluster(int index) async {
    final config = _kubeconfigs[index];
    final l10n = AppLocalizations.of(context)!;
    
    // Show loading indicator
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    // Validate connection
    final canConnect = await _validateConnection(config);
    
    // Hide loading
    if (mounted) Navigator.pop(context);
    
    if (!canConnect) {
      // Show error dialog
      if (mounted) {
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 12),
                Text('连接失败'),
              ],
            ),
            content: Text(
              config.errorMessage ?? '无法连接到 Kubernetes 集群，请检查配置文件是否正确',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
      return;
    }
    
    // Connection successful - set as active and navigate
    setState(() {
      _selectedIndex = index;
      for (var i = 0; i < _kubeconfigs.length; i++) {
        _kubeconfigs[i] = _kubeconfigs[i].copyWith(
          isActive: i == index,
        );
      }
    });
    
    // Navigate to dashboard
    if (mounted) {
      Navigator.of(context).push<void>(
        MaterialPageRoute(builder: (_) => const DashboardView()),
      );
    }
  }

  Future<void> _importKubeconfig() async {
    print('🔍 DEBUG: Import kubeconfig button clicked');
    try {
      print('🔍 DEBUG: Calling FilePicker.platform.pickFiles...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['yaml', 'yml', 'config'],
        dialogTitle: 'Select Kubeconfig File',
      );
      print('🔍 DEBUG: FilePicker returned: ${result != null ? "result" : "null"}');
      
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileName = result.files.single.name;
        print('🔍 DEBUG: Selected file: $fileName at $filePath');
        
        // In a real implementation, you would parse the kubeconfig file here
        // For now, we'll just show a success message
        setState(() {
          _kubeconfigs.add(KubeconfigModel(
            name: 'Imported: $fileName',
            context: 'imported-context',
            cluster: filePath,
            user: 'imported-user',
            namespace: 'default',
          ));
        });
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully imported: $fileName'),
            backgroundColor: Colors.green.shade700,
          ),
        );
        print('🔍 DEBUG: File added to list successfully');
      } else {
        print('🔍 DEBUG: User cancelled file selection or path is null');
      }
    } catch (e, stackTrace) {
      print('❌ ERROR: FilePicker exception: $e');
      print('❌ ERROR: Stack trace: $stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to import kubeconfig: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  void _editYamlKubeconfig(int index) async {
    final config = _kubeconfigs[index];
    showDialog<void>(
      context: context,
      builder: (context) => YamlEditorDialog(
        title: '编辑 ${config.name} 配置',
        initialName: config.name,
        initialContent: config.content ?? '',
        onSave: (newName, newContent) {
          setState(() {
            _kubeconfigs[index] = config.copyWith(
              name: newName,
              content: newContent,
            );
          });
        },
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
      appBar: const GlobalAppBar(),
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
                                  onTap:() => _connectToCluster(index),
                                  onEdit: () => _editYamlKubeconfig(index),
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
}

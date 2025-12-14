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
import 'dart:io';

import 'package:kxs/core/services/k8s_provider.dart';

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
      content: '''
apiVersion: v1
clusters:
- cluster:
    server: https://dev.k8s.local
    certificate-authority-data: DATA+OMITTED
  name: dev.k8s.local
contexts:
- context:
    cluster: dev.k8s.local
    user: dev-admin
  name: dev-context
current-context: dev-context
kind: Config
preferences: {}
users:
- name: dev-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
''',
    ),
    const KubeconfigModel(
      name: 'Production Cluster',
      context: 'prod-context',
      cluster: 'prod.k8s.local',
      user: 'prod-admin',
      namespace: 'kube-system',
      content: '''
apiVersion: v1
clusters:
- cluster:
    server: https://prod.k8s.local
  name: prod.k8s.local
contexts:
- context:
    cluster: prod.k8s.local
    user: prod-admin
  name: prod-context
current-context: prod-context
kind: Config
''',
    ),
    const KubeconfigModel(
      name: 'Staging Cluster',
      context: 'staging-context',
      cluster: 'staging.k8s.local',
      user: 'staging-admin',
      content: '''
apiVersion: v1
clusters:
- cluster:
    server: https://staging.k8s.local
  name: staging.k8s.local
contexts:
- context:
    cluster: staging.k8s.local
    user: staging-admin
  name: staging-context
current-context: staging-context
kind: Config
''',
    ),
    const KubeconfigModel(
      name: 'Invalid Cluster',
      context: 'invalid-context',
      cluster: 'invalid.k8s.local',
      isValid: false,
      errorMessage: 'Failed to connect: context not found in kubeconfig',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadDefaultKubeconfigs();
  }

  Future<void> _loadDefaultKubeconfigs() async {
    try {
      final home = Platform.environment['HOME'] ?? Platform.environment['UserProfile'];
      if (home == null) return;
      
      final kubeDir = Directory('$home/.kube');
      if (!await kubeDir.exists()) return;
      
      final entities = await kubeDir.list().toList();
      for (var entity in entities) {
        if (entity is File) {
          final name = entity.uri.pathSegments.last;
          // Load 'config' or common extensions
          if (name == 'config' || name.endsWith('.yaml') || name.endsWith('.yml') || name.endsWith('.conf') || !name.contains('.')) {
             try {
               final content = await entity.readAsString();
               // Basic check to see if it looks like yaml/kubeconfig
               if (content.contains('apiVersion:') && content.contains('kind: Config')) {
                 if (mounted) {
                   setState(() {
                      // Avoid duplicates
                      if (!_kubeconfigs.any((k) => k.name == name)) {
                        _kubeconfigs.add(KubeconfigModel(
                          name: name,
                          context: 'context-$name',
                          cluster: 'cluster-from-$name',
                          user: 'user',
                          content: content,
                          isValid: true,
                        ));
                      }
                   });
                 }
               }
             } catch (e) {
               print('Failed to read potential kubeconfig $name: $e');
             }
          }
        }
      }
    } catch (e) {
      print('Error loading default kubeconfigs: $e');
    }
  }

  void _createKubeconfig() {
    final newConfig = const KubeconfigModel(
      name: 'New Config',
      context: 'new-context',
      cluster: 'new-cluster',
      content: '''apiVersion: v1
clusters:
- cluster:
    server: https://kubernetes.default.svc
    certificate-authority-data: 
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: 
    client-key-data: 
''',
      isValid: true,
    );
    
    // Open editor immediately
    showDialog<void>(
      context: context,
      builder: (context) => YamlEditorDialog(
        title: '新建配置',
        initialName: newConfig.name,
        initialContent: newConfig.content ?? '',
        onSave: (newName, newContent) {
          setState(() {
            _kubeconfigs.add(newConfig.copyWith(
              name: newName,
              content: newContent,
            ));
          });
        },
      ),
    );
  }

  int? _selectedIndex;

  Future<void> _connectToCluster(int index) async {
    final config = _kubeconfigs[index];
    
    // Show loading indicator
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      // Connect using the provider (writes file, checks with kubectl)
      // For invalid mocks (isValid: false), maintain existing behavior?
      // Since mocks might fail parsing, we check isValid first if we want to support the "Invalid Cluster" test case.
      if (!config.isValid && config.errorMessage != null) {
         throw Exception(config.errorMessage);
      }
      
      await ref.read(k8sControllerProvider.notifier).connect(config);
      
      // Hide loading
      if (mounted) Navigator.pop(context);

      // Connection successful - set as active and navigate
      setState(() {
        _selectedIndex = index;
        for (var i = 0; i < _kubeconfigs.length; i++) {
          _kubeconfigs[i] = _kubeconfigs[i].copyWith(
            isActive: i == index,
          );
        }
      });
      
      if (mounted) {
        Navigator.of(context).push<void>(
          MaterialPageRoute(builder: (_) => const DashboardView()),
        );
      }
      
    } catch (e) {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context); // Hide loading
      
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
            content: Text(e.toString().replaceAll('Exception: ', '')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _importKubeconfig() async {
    print('🔍 DEBUG: Import kubeconfig button clicked');
    try {
      print('🔍 DEBUG: Calling FilePicker.platform.pickFiles...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any, // Allow any file type (including no extension)
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
                              onImport: _importKubeconfig,
                              onCreate: _createKubeconfig,
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

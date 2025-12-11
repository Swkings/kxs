import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/features/resources/controllers/pods_controller.dart';
import 'package:kxs/shared/widgets/glass_card.dart';
import 'package:kxs/shared/models/pod_model.dart';
import 'package:kxs/features/resources/views/pod_details_view.dart';
import 'package:kxs/core/providers/selected_resource_provider.dart';

class PodsView extends ConsumerStatefulWidget {
  final String namespace;

  const PodsView({super.key, this.namespace = 'default'});

  @override
  ConsumerState<PodsView> createState() => _PodsViewState();
}

class _PodsViewState extends ConsumerState<PodsView> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToSelected(int selectedIndex, int itemCount) {
    if (itemCount == 0) return;
    
    const itemHeight = 76.0; // Approximate height of each item
    final targetScroll = selectedIndex * itemHeight;
    final viewportHeight = _scrollController.position.viewportDimension;
    final currentScroll = _scrollController.offset;
    
    // Scroll if selected item is out of view
    if (targetScroll < currentScroll) {
      _scrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    } else if (targetScroll + itemHeight > currentScroll + viewportHeight) {
      _scrollController.animateTo(
        targetScroll - viewportHeight + itemHeight + 20,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final podsAsync = ref.watch(podsControllerProvider(widget.namespace));
    final selectedIndex = ref.watch(selectedResourceIndexProvider);

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          podsAsync.whenData((pods) {
            if (pods.isEmpty) return;
            
            // j or down arrow - move down
            if (event.logicalKey == LogicalKeyboardKey.keyJ ||
                event.logicalKey == LogicalKeyboardKey.arrowDown) {
              ref.read(selectedResourceIndexProvider.notifier).moveDown(pods.length - 1);
              _scrollToSelected(ref.read(selectedResourceIndexProvider), pods.length);
            }
            // k or up arrow - move up
            else if (event.logicalKey == LogicalKeyboardKey.keyK ||
                     event.logicalKey == LogicalKeyboardKey.arrowUp) {
              ref.read(selectedResourceIndexProvider.notifier).moveUp();
              _scrollToSelected(ref.read(selectedResourceIndexProvider), pods.length);
            }
            // Enter - view details
            else if (event.logicalKey == LogicalKeyboardKey.enter) {
              final pod = pods[selectedIndex.clamp(0, pods.length - 1)];
              showDialog(
                context: context,
                builder: (context) => PodDetailsView(
                  namespace: pod.namespace,
                  podName: pod.name,
                ),
              );
            }
            // l - view logs
            else if (event.logicalKey == LogicalKeyboardKey.keyL) {
              final pod = pods[selectedIndex.clamp(0, pods.length - 1)];
              showDialog(
                context: context,
                builder: (context) => PodDetailsView(
                  namespace: pod.namespace,
                  podName: pod.name,
                  initialTab: 2, // Logs tab
                ),
              );
            }
            // y - view YAML
            else if (event.logicalKey == LogicalKeyboardKey.keyY) {
              final pod = pods[selectedIndex.clamp(0, pods.length - 1)];
              showDialog(
                context: context,
                builder: (context) => PodDetailsView(
                  namespace: pod.namespace,
                  podName: pod.name,
                  initialTab: 1, // YAML tab
                ),
              );
            }
            // d - delete pod (with confirmation)
            else if (event.logicalKey == LogicalKeyboardKey.keyD) {
              final pod = pods[selectedIndex.clamp(0, pods.length - 1)];
              _showDeleteConfirmation(context, ref, pod);
            }
            // Ctrl+R - refresh
            else if (event.logicalKey == LogicalKeyboardKey.keyR &&
                     HardwareKeyboard.instance.isControlPressed) {
              ref.invalidate(podsControllerProvider(widget.namespace));
            }
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Pods (${widget.namespace})',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: podsAsync.when(
              data: (pods) {
                if (pods.isEmpty) {
                  return const Center(
                    child: Text('No pods found', style: TextStyle(color: Colors.white54)),
                  );
                }
                
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: pods.length,
                  itemBuilder: (context, index) {
                    final pod = pods[index];
                    final isSelected = index == selectedIndex;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        opacity: isSelected ? 0.8 : 0.5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: ListTile(
                            leading: _buildStatusIndicator(pod),
                            title: Text(
                              pod.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              pod.status,
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Text(
                              _calculateAge(pod.creationTimestamp),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            onTap: () {
                              ref.read(selectedResourceIndexProvider.notifier).select(index);
                              showDialog(
                                context: context,
                                builder: (context) => PodDetailsView(
                                  namespace: pod.namespace,
                                  podName: pod.name,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(PodModel pod) {
    Color color = Colors.grey;
    if (pod.status == 'Running') color = Colors.greenAccent;
    if (pod.status == 'Pending') color = Colors.orangeAccent;
    if (pod.status == 'Failed' || pod.status == 'Error') color = Colors.redAccent;
    
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  String _calculateAge(DateTime? creationTime) {
    if (creationTime == null) return '-';
    final diff = DateTime.now().difference(creationTime);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    return '${diff.inMinutes}m';
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, PodModel pod) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pod'),
        content: Text('Are you sure you want to delete pod "${pod.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // TODO: Implement actual delete via K8s API
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleting pod ${pod.name}...'),
                  backgroundColor: Colors.orange,
                ),
              );
              // After delete, refresh the list
              await Future.delayed(const Duration(seconds: 1));
              ref.invalidate(podsControllerProvider(widget.namespace));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

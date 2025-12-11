import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/features/resources/controllers/nodes_controller.dart';
import 'package:kxs/shared/widgets/glass_card.dart';
import 'package:kxs/shared/models/node_model.dart';
import 'package:kxs/core/providers/selected_resource_provider.dart';

class NodesView extends ConsumerStatefulWidget {
  const NodesView({super.key});

  @override
  ConsumerState<NodesView> createState() => _NodesViewState();
}

class _NodesViewState extends ConsumerState<NodesView> {
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
    
    const itemHeight = 80.0;
    final targetScroll = selectedIndex * itemHeight;
    final viewportHeight = _scrollController.position.viewportDimension;
    final currentScroll = _scrollController.offset;
    
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
    final nodesAsync = ref.watch(nodesControllerProvider);
    final selectedIndex = ref.watch(selectedResourceIndexProvider);

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          nodesAsync.whenData((nodes) {
            if (nodes.isEmpty) return;
            
            // j or down arrow - move down
            if (event.logicalKey == LogicalKeyboardKey.keyJ ||
                event.logicalKey == LogicalKeyboardKey.arrowDown) {
              ref.read(selectedResourceIndexProvider.notifier).moveDown(nodes.length - 1);
              _scrollToSelected(ref.read(selectedResourceIndexProvider), nodes.length);
            }
            // k or up arrow - move up
            else if (event.logicalKey == LogicalKeyboardKey.keyK ||
                     event.logicalKey == LogicalKeyboardKey.arrowUp) {
              ref.read(selectedResourceIndexProvider.notifier).moveUp();
              _scrollToSelected(ref.read(selectedResourceIndexProvider), nodes.length);
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
              'Nodes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: nodesAsync.when(
              data: (nodes) {
                if (nodes.isEmpty) {
                  return const Center(
                    child: Text('No nodes found', style: TextStyle(color: Colors.white54)),
                  );
                }
                
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: nodes.length,
                  itemBuilder: (context, index) {
                    final node = nodes[index];
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
                            leading: _buildStatusIndicator(node),
                            title: Text(
                              node.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              '${node.status} • ${node.version}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  node.status,
                                  style: TextStyle(
                                    color: node.status == 'Ready' ? Colors.greenAccent : Colors.orangeAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _calculateAge(node.creationTimestamp),
                                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                                ),
                              ],
                            ),
                            onTap: () {
                              ref.read(selectedResourceIndexProvider.notifier).select(index);
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

  Widget _buildStatusIndicator(NodeModel node) {
    Color color = node.status == 'Ready' ? Colors.greenAccent : Colors.orangeAccent;
    
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
}

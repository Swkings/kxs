import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/features/resources/controllers/services_controller.dart';
import 'package:kxs/shared/widgets/glass_card.dart';
import 'package:kxs/shared/models/service_model.dart';
import 'package:kxs/core/providers/selected_resource_provider.dart';

class ServicesView extends ConsumerStatefulWidget {
  final String namespace;

  const ServicesView({super.key, this.namespace = 'default'});

  @override
  ConsumerState<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends ConsumerState<ServicesView> {
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
    
    const itemHeight = 76.0;
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
    final servicesAsync = ref.watch(servicesControllerProvider(widget.namespace));
    final selectedIndex = ref.watch(selectedResourceIndexProvider);

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          servicesAsync.whenData((services) {
            if (services.isEmpty) return;
            
            // j or down arrow - move down
            if (event.logicalKey == LogicalKeyboardKey.keyJ ||
                event.logicalKey == LogicalKeyboardKey.arrowDown) {
              ref.read(selectedResourceIndexProvider.notifier).moveDown(services.length - 1);
              _scrollToSelected(ref.read(selectedResourceIndexProvider), services.length);
            }
            // k or up arrow - move up
            else if (event.logicalKey == LogicalKeyboardKey.keyK ||
                     event.logicalKey == LogicalKeyboardKey.arrowUp) {
              ref.read(selectedResourceIndexProvider.notifier).moveUp();
              _scrollToSelected(ref.read(selectedResourceIndexProvider), services.length);
            }
            // Ctrl+R - refresh
            else if (event.logicalKey == LogicalKeyboardKey.keyR &&
                     HardwareKeyboard.instance.isControlPressed) {
              ref.invalidate(servicesControllerProvider(widget.namespace));
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
              'Services (${widget.namespace})',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: servicesAsync.when(
              data: (services) {
                if (services.isEmpty) {
                  return const Center(
                    child: Text('No services found', style: TextStyle(color: Colors.white54)),
                  );
                }
                
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
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
                            leading: _buildTypeIndicator(service),
                            title: Text(
                              service.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              '${service.type} | ${service.clusterIP}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Text(
                              _formatPorts(service.ports),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
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

  Widget _buildTypeIndicator(ServiceModel service) {
    Color color = Colors.blue;
    IconData icon = Icons.cloud;
    
    switch (service.type) {
      case 'ClusterIP':
        color = Colors.blue;
        icon = Icons.cloud;
        break;
      case 'NodePort':
        color = Colors.orange;
        icon = Icons.router;
        break;
      case 'LoadBalancer':
        color = Colors.green;
        icon = Icons.balance;
        break;
      case 'ExternalName':
        color = Colors.purple;
        icon = Icons.link;
        break;
    }
    
    return Icon(icon, color: color, size: 24);
  }

  String _formatPorts(List<int> ports) {
    if (ports.isEmpty) return '-';
    if (ports.length == 1) return ports.first.toString();
    if (ports.length <= 3) return ports.join(', ');
    return '${ports.take(2).join(', ')}... (+${ports.length - 2})';
  }
}

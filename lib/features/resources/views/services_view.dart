import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/features/resources/controllers/services_controller.dart';
import 'package:kxs/shared/widgets/k9s_table.dart';
import 'package:kxs/shared/models/service_model.dart';

class ServicesView extends ConsumerStatefulWidget {
  final String namespace;

  const ServicesView({super.key, this.namespace = 'default'});

  @override
  ConsumerState<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends ConsumerState<ServicesView> {
  int _highlightedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesControllerProvider(widget.namespace));

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: Container(
              color: Colors.cyan,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: double.infinity,
              child: Text(
                'SERVICES (${widget.namespace})',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Courier',
                ),
              ),
            ),
          ),
          Expanded(
            child: servicesAsync.when(
              data: (services) {
                if (services.isEmpty) {
                  return const Center(
                    child: Text('No services found', style: TextStyle(color: Colors.white54, fontFamily: 'Courier')),
                  );
                }

                return RawKeyboardListener(
                  focusNode: FocusNode(), 
                  // We handle shortcuts here if we want to add specific actions like Edit/Delete
                  // For now, K9sTable handles navigation.
                  onKey: (event) {
                    if (event is RawKeyDownEvent) {
                      // Add specific service actions here
                      if (event.logicalKey == LogicalKeyboardKey.keyR && event.isControlPressed) {
                         ref.invalidate(servicesControllerProvider(widget.namespace));
                      }
                    }
                  },
                  child: K9sTable(
                    onHighlightChanged: (index) {
                      setState(() {
                        _highlightedIndex = index;
                      });
                    },
                    columns: const [
                      K9sTableColumn(title: 'NAME', flex: 3),
                      K9sTableColumn(title: 'TYPE', flex: 2),
                      K9sTableColumn(title: 'CLUSTER-IP', flex: 2),
                      K9sTableColumn(title: 'PORTS', flex: 2),
                      K9sTableColumn(title: 'AGE', flex: 1),
                    ],
                    rows: services.map((svc) {
                      return K9sTableRow(
                        cells: [
                          svc.name,
                          svc.type,
                          svc.clusterIP,
                          _formatPorts(svc.ports),
                          _calculateAge(svc.creationTimestamp),
                        ],
                        onSelect: () {
                          // Handle selection (details view?)
                        },
                      );
                    }).toList(),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.red, fontFamily: 'Courier'),
                ),
              ),
            ),
          ),
          // Status bar
          Container(
            color: Colors.cyan,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Text(
                  'Service: ${servicesAsync.value?.isNotEmpty == true && _highlightedIndex < (servicesAsync.value?.length ?? 0) ? servicesAsync.value![_highlightedIndex].name : ""}',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
                ),
                const Spacer(),
                const Text(
                  '<Ctrl+R> Refresh',
                  style: TextStyle(color: Colors.black, fontFamily: 'Courier', fontSize: 12),
                ),
              ],
            ),
          ),
        ],
    );
  }

  String _formatPorts(List<int> ports) {
    if (ports.isEmpty) return '-';
    if (ports.length == 1) return ports.first.toString();
    if (ports.length <= 2) return ports.join(',');
    return '${ports[0]},...';
  }

  String _calculateAge(DateTime? creationTimestamp) {
    if (creationTimestamp == null) return '?';
    final duration = DateTime.now().difference(creationTimestamp);
    if (duration.inDays > 0) return '${duration.inDays}d';
    if (duration.inHours > 0) return '${duration.inHours}h';
    return '${duration.inMinutes}m';
  }
}

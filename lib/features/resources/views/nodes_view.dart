import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/features/resources/controllers/nodes_controller.dart';
import 'package:kxs/shared/models/node_model.dart';
import 'package:kxs/shared/widgets/k9s_table.dart';

class NodesView extends ConsumerWidget {
  const NodesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodesAsync = ref.watch(nodesControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Nodes',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontFamily: 'Courier', 
              fontWeight: FontWeight.bold,
            ),
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

              // Define Columns
              final columns = const [
                K9sTableColumn(title: 'NAME', flex: 3),
                K9sTableColumn(title: 'STATUS', flex: 1),
                K9sTableColumn(title: 'ROLES', flex: 2),
                K9sTableColumn(title: 'AGE', flex: 1),
                K9sTableColumn(title: 'VERSION', flex: 1),
              ];

              // Map Rows
              final rows = nodes.map((node) {
                return K9sTableRow(
                  cells: [
                    node.name,
                    node.status,
                    node.role ?? '-',
                    _calculateAge(node.creationTimestamp),
                    node.version,
                  ],
                  statusColor: node.status == 'Ready' ? Colors.green : Colors.red,
                  onSelect: () {
                    // Handle selection/navigation
                  },
                );
              }).toList();
              
              return Padding(
                padding: const EdgeInsets.all(16),
                child: K9sTable(
                  columns: columns, 
                  rows: rows,
                  onEnter: () {
                    // Handle Enter key on selected row
                  },
                ),
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

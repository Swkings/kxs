import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/features/resources/controllers/pods_controller.dart';
import 'package:kxs/shared/models/pod_model.dart';
import 'package:kxs/shared/widgets/k9s_table.dart';
import 'package:kxs/features/resources/views/pod_details_view.dart';
import 'package:kxs/core/services/cluster_service_provider.dart';

class PodsView extends ConsumerStatefulWidget {
  final String namespace;

  const PodsView({super.key, this.namespace = 'default'});

  @override
  ConsumerState<PodsView> createState() => _PodsViewState();
}

class _PodsViewState extends ConsumerState<PodsView> {
  int _highlightedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final podsAsync = ref.watch(podsControllerProvider(widget.namespace));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Pods (${widget.namespace})',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontFamily: 'Courier',
              fontWeight: FontWeight.bold,
            ),
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

              // Define Columns
              final columns = const [
                K9sTableColumn(title: 'NAME', flex: 3),
                K9sTableColumn(title: 'READY', flex: 1), 
                K9sTableColumn(title: 'STATUS', flex: 1),
                K9sTableColumn(title: 'RESTARTS', flex: 1),
                K9sTableColumn(title: 'AGE', flex: 1),
              ];

              // Map Rows
              final rows = pods.map((pod) {
                return K9sTableRow(
                  cells: [
                    pod.name,
                    '1/1', // Placeholder
                    pod.status,
                    (pod.restarts ?? 0).toString(),
                    pod.age ?? '-',
                  ],
                  statusColor: _getStatusColor(pod.status),
                  onSelect: () => _openDetails(pod),
                );
              }).toList();

              return Padding(
                padding: const EdgeInsets.all(16),
                child: K9sTable(
                  columns: columns,
                  rows: rows,
                  onEnter: () {
                     if (pods.isNotEmpty) {
                        final index = _highlightedIndex.clamp(0, pods.length - 1);
                        _openDetails(pods[index]);
                     }
                  },
                  onHighlightChanged: (index) {
                     setState(() {
                        _highlightedIndex = index;
                     });
                  },
                  onKeyDown: (event, index) {
                    final pod = pods[index];
                    if (event.logicalKey == LogicalKeyboardKey.keyD && event.isControlPressed) {
                      _showDeleteConfirmation(context, ref, pod);
                    } else if (event.logicalKey == LogicalKeyboardKey.keyL) {
                      _openDetails(pod, initialTab: 2);
                    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
                       // Shell
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Shell for ${pod.name} (Not implemented yet)')));
                    }
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

  void _openDetails(PodModel pod, {int initialTab = 0}) {
    showDialog(
      context: context,
      builder: (context) => PodDetailsView(
        namespace: pod.namespace,
        podName: pod.name,
        initialTab: initialTab,
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Running') return Colors.greenAccent;
    if (status == 'Pending') return Colors.orangeAccent;
    if (status == 'Failed' || status == 'Error' || status == 'CrashLoopBackOff') return Colors.redAccent;
    return Colors.white;
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
              try {
                final clusterService = ref.read(clusterServiceProvider);
                await clusterService.deletePod(pod.namespace, pod.name);
                
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleting pod ${pod.name}...')),
                );
                
                ref.invalidate(podsControllerProvider(widget.namespace));
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete: $e')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

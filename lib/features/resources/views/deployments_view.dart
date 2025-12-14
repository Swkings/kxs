import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/features/resources/controllers/deployments_controller.dart';
import 'package:kxs/shared/widgets/k9s_table.dart';
import 'package:kxs/shared/models/deployment_model.dart';

class DeploymentsView extends ConsumerStatefulWidget {
  final String namespace;

  const DeploymentsView({super.key, this.namespace = 'default'});

  @override
  ConsumerState<DeploymentsView> createState() => _DeploymentsViewState();
}

class _DeploymentsViewState extends ConsumerState<DeploymentsView> {
  int _highlightedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final deploymentsAsync = ref.watch(deploymentsControllerProvider(widget.namespace));

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
                'DEPLOYMENTS (${widget.namespace})',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Courier',
                ),
              ),
            ),
          ),
          Expanded(
            child: deploymentsAsync.when(
              data: (deployments) {
                if (deployments.isEmpty) {
                  return const Center(
                    child: Text('No deployments found', style: TextStyle(color: Colors.white54, fontFamily: 'Courier')),
                  );
                }

                return RawKeyboardListener(
                  focusNode: FocusNode(), 
                  onKey: (event) {
                    if (event is RawKeyDownEvent) {
                      if (event.logicalKey == LogicalKeyboardKey.keyR && event.isControlPressed) {
                         ref.invalidate(deploymentsControllerProvider(widget.namespace));
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
                      K9sTableColumn(title: 'READY', flex: 1),
                      K9sTableColumn(title: 'UP-TO-DATE', flex: 1),
                      K9sTableColumn(title: 'AVAILABLE', flex: 1),
                      K9sTableColumn(title: 'AGE', flex: 1),
                    ],
                    rows: deployments.map((deploy) {
                      return K9sTableRow(
                        cells: [
                          deploy.name,
                          '${deploy.readyReplicas}/${deploy.replicas}',
                          deploy.upToDateReplicas.toString(),
                          deploy.availableReplicas.toString(),
                          deploy.age,
                        ],
                        onSelect: () {
                          // Handle selection
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
                  'Deployment: ${deploymentsAsync.value?.isNotEmpty == true && _highlightedIndex < (deploymentsAsync.value?.length ?? 0) ? deploymentsAsync.value![_highlightedIndex].name : ""}',
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
}

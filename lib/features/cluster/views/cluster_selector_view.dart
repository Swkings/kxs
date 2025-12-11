import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/core/services/k8s_provider.dart';
import 'package:kxs/shared/widgets/glass_card.dart';

class ClusterSelectorView extends ConsumerWidget {
  const ClusterSelectorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final k8sState = ref.watch(k8sControllerProvider);

    return k8sState.when(
      data: (state) {
        final currentContext = state.currentContext ?? 'No Context';
        final contexts = state.contexts;

        return GlassCard(
          child: ExpansionTile(
            title: Text(
              currentContext,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            leading: const Icon(Icons.hub_rounded, color: Colors.white),
            children: contexts.map((ctx) {
              final isSelected = ctx == currentContext;
              return ListTile(
                dense: true,
                title: Text(
                  ctx,
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white70,
                    fontSize: 12,
                  ),
                ),
                trailing: isSelected 
                  ? Icon(Icons.check, size: 14, color: Theme.of(context).colorScheme.primary) 
                  : null,
                onTap: () {
                 ref.read(k8sControllerProvider.notifier).setContext(ctx);
                },
              );
            }).toList(),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err', style: const TextStyle(color: Colors.red)),
    );
  }
}

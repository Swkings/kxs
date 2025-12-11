import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/features/resources/controllers/namespaces_controller.dart';

class NamespaceSelectorView extends ConsumerWidget {
  const NamespaceSelectorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namespacesAsync = ref.watch(namespacesControllerProvider);
    final selectedNamespace = ref.watch(selectedNamespaceProvider);

    return namespacesAsync.when(
      data: (namespaces) {
        return ExpansionTile(
          title: const Text('Namespace', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70)),
          subtitle: Text(selectedNamespace, style: const TextStyle(fontWeight: FontWeight.bold)),
          children: [
            SizedBox(
              height: 200, // Limit height
              child: ListView.builder(
                itemCount: namespaces.length,
                itemBuilder: (context, index) {
                  final ns = namespaces[index];
                  final isSelected = ns.name == selectedNamespace;
                  return ListTile(
                    dense: true,
                    title: Text(ns.name),
                    selected: isSelected,
                    onTap: () {
                      ref.read(selectedNamespaceProvider.notifier).select(ns.name);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (err, stack) => Text('Error: $err', style: const TextStyle(color: Colors.red, fontSize: 10)),
    );
  }
}

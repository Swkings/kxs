import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KeyboardHelpOverlay extends ConsumerWidget {
  final VoidCallback onClose;

  const KeyboardHelpOverlay({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          color: Colors.black54,
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {}, // Prevent closing when clicking inside
            child: Container(
              width: 700,
              constraints: const BoxConstraints(maxHeight: 600),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1d2e).withValues(alpha: 0.98),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.keyboard,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Keyboard Shortcuts',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: onClose,
                        ),
                      ],
                    ),
                  ),

                  // Shortcuts list
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection('Global', [
                            _ShortcutItem(':', 'Open command palette'),
                            _ShortcutItem('Esc', 'Close palette/dialogs'),
                            _ShortcutItem('Ctrl+Q', 'Return to home'),
                            _ShortcutItem('?', 'Show this help'),
                          ]),
                          const SizedBox(height: 24),
                          
                          _buildSection('Navigation', [
                            _ShortcutItem('j / ↓', 'Move selection down'),
                            _ShortcutItem('k / ↑', 'Move selection up'),
                            _ShortcutItem('Enter', 'View details'),
                          ]),
                          const SizedBox(height: 24),
                          
                          _buildSection('Resource Actions', [
                            _ShortcutItem('l', 'View logs (Pods)'),
                            _ShortcutItem('y', 'View YAML'),
                            _ShortcutItem('d', 'Delete resource'),
                            _ShortcutItem('Ctrl+R', 'Refresh list'),
                          ]),
                          const SizedBox(height: 24),
                          
                          _buildSection('Command Palette', [
                            _ShortcutItem(':pods', 'Switch to Pods view'),
                            _ShortcutItem(':nodes', 'Switch to Nodes view'),
                            _ShortcutItem(':services', 'Switch to Services'),
                            _ShortcutItem(':overview', 'Cluster overview'),
                            _ShortcutItem(':q', 'Quit to home'),
                          ]),
                        ],
                      ),
                    ),
                  ),

                  // Footer
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Press ',
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                        _buildKey('Esc'),
                        const Text(
                          ' or ',
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                        _buildKey('?'),
                        const Text(
                          ' to close',
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<_ShortcutItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              _buildKey(item.keys),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildKey(String label) {
    return Container(
      constraints: const BoxConstraints(minWidth: 80),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class _ShortcutItem {
  final String keys;
  final String description;

  _ShortcutItem(this.keys, this.description);
}

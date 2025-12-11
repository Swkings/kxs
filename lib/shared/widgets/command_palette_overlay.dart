import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/features/dashboard/controllers/dashboard_controller.dart';
import 'package:kxs/shared/widgets/command_palette_provider.dart';

class K9sCommand {
  final String name;
  final String description;
  final DashboardTab? targetTab;
  final VoidCallback? action;

  K9sCommand({
    required this.name,
    required this.description,
    this.targetTab,
    this.action,
  });
}

class CommandPaletteOverlay extends ConsumerStatefulWidget {
  const CommandPaletteOverlay({super.key});

  @override
  ConsumerState<CommandPaletteOverlay> createState() => _CommandPaletteOverlayState();
}

class _CommandPaletteOverlayState extends ConsumerState<CommandPaletteOverlay> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _selectedIndex = 0;

  List<K9sCommand> get _allCommands => [
    K9sCommand(name: 'pods', description: 'View Pods', targetTab: DashboardTab.pods),
    K9sCommand(name: 'nodes', description: 'View Nodes', targetTab: DashboardTab.nodes),
    K9sCommand(name: 'services', description: 'View Services', targetTab: DashboardTab.services),
    K9sCommand(name: 'overview', description: 'Cluster Overview', targetTab: DashboardTab.overview),
    K9sCommand(
      name: 'q',
      description: 'Quit to Home',
      action: () => Navigator.of(context).pop(),
    ),
  ];

  List<K9sCommand> get _filteredCommands {
    if (_controller.text.isEmpty) return _allCommands;
    final query = _controller.text.toLowerCase();
    return _allCommands.where((cmd) =>
      cmd.name.toLowerCase().contains(query) ||
      cmd.description.toLowerCase().contains(query)
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _executeCommand(K9sCommand cmd) {
    if (cmd.targetTab != null) {
      ref.read(dashboardControllerProvider.notifier).setTab(cmd.targetTab!);
    } else if (cmd.action != null) {
      cmd.action!();
    }
    
    // Close palette
    ref.read(commandPaletteVisibleProvider.notifier).hide();
  }

  void _close() {
    ref.read(commandPaletteVisibleProvider.notifier).hide();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCommands;
    
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: _close,
        child: Container(
          color: Colors.black54,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 120),
          child: GestureDetector(
            onTap: () {}, // Prevent closing when clicking inside
            child: Container(
              width: 600,
              constraints: const BoxConstraints(maxHeight: 400),
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
                  // Search input
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Type a command...',
                        hintStyle: TextStyle(color: Colors.white30),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onChanged: (_) => setState(() {
                        _selectedIndex = 0;
                      }),
                      onSubmitted: (_) {
                        if (filtered.isNotEmpty) {
                          _executeCommand(filtered[_selectedIndex]);
                        }
                      },
                    ),
                  ),
                  
                  // Command list
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final cmd = filtered[index];
                        final isSelected = index == _selectedIndex;
                        
                        return InkWell(
                          onTap: () => _executeCommand(cmd),
                          onHover: (hovering) {
                            if (hovering) {
                              setState(() => _selectedIndex = index);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                                  : Colors.transparent,
                              border: Border(
                                left: BorderSide(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getCommandIcon(cmd.name),
                                  size: 22,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.white70,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ':${cmd.name}',
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.white.withValues(alpha: 0.87),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        cmd.description,
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.keyboard_return,
                                    size: 18,
                                    color: Colors.white54,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Footer hint
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHintKey('↑↓'),
                        const Text(' navigate  ', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        _buildHintKey('Enter'),
                        const Text(' select  ', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        _buildHintKey('Esc'),
                        const Text(' close', style: TextStyle(color: Colors.white54, fontSize: 12)),
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

  Widget _buildHintKey(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
    );
  }

  IconData _getCommandIcon(String name) {
    switch (name) {
      case 'pods':
        return Icons.dns_rounded;
      case 'nodes':
        return Icons.computer_rounded;
      case 'services':
        return Icons.cloud_outlined;
      case 'overview':
        return Icons.dashboard_rounded;
      case 'q':
        return Icons.exit_to_app;
      default:
        return Icons.code;
    }
  }
}

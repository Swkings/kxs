import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/features/commands/models/k9s_command.dart';
import 'package:kxs/features/commands/services/command_parser.dart';
import 'package:kxs/features/commands/providers/command_provider.dart';
import 'package:kxs/features/dashboard/controllers/dashboard_controller.dart';
import 'package:kxs/shared/widgets/command_palette_provider.dart';

class CommandPaletteOverlay extends ConsumerStatefulWidget {
  const CommandPaletteOverlay({super.key});

  @override
  ConsumerState<CommandPaletteOverlay> createState() => _CommandPaletteOverlayState();
}

class _CommandPaletteOverlayState extends ConsumerState<CommandPaletteOverlay> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  List<K9sCommand> get _filteredCommands {
    final query = _controller.text.trim();
    
    // Don't require : prefix - just use the raw query
    if (query.isEmpty) {
      final history = ref.watch(commandHistoryProvider);
      if (history.isNotEmpty) {
        return history
            .map((String h) => CommandParser.parse(h))
            .where((K9sCommand? c) => c != null)
            .cast<K9sCommand>()
            .toList();
      }
      return CommandParser.allCommands;
    }
    
    return CommandParser.getSuggestions(query);
  }

  @override
  void initState() {
    super.initState();
    // Start with empty, no : prefix needed
    _controller.text = '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _executeCommand(K9sCommand cmd) {
    ref.read(commandHistoryProvider.notifier).add(':${cmd.name}');
    
    if (cmd.targetTab != null) {
      ref.read(dashboardControllerProvider.notifier).setTab(cmd.targetTab!);
    } else if (cmd.action != null) {
      cmd.action!();
      // Special handling for quit command
      if (cmd.name == 'quit' || cmd.name == 'q') {
        Navigator.of(context).pop(); // Return to home
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Command ":${cmd.name}" not yet implemented'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
    
    _close();
  }

  void _close() {
    ref.read(commandPaletteVisibleProvider.notifier).hide();
  }

  void _scrollToSelected() {
    // Scroll to keep selected item centered in viewport
    if (_scrollController.hasClients) {
      final double itemHeight = 60.0; // Approximate item height
      final double viewportHeight = _scrollController.position.viewportDimension;
      final double currentScroll = _scrollController.offset;
      
      // Calculate ideal scroll position to center the selected item
      final double idealOffset = (_selectedIndex * itemHeight) - (viewportHeight / 2) + (itemHeight / 2);
      
      // Get scroll bounds
      final double minScroll = _scrollController.position.minScrollExtent;
      final double maxScroll = _scrollController.position.maxScrollExtent;
      
      // Clamp to valid range
      final double targetOffset = idealOffset.clamp(minScroll, maxScroll);
      
      // Only scroll if the change is significant (> 1px) to avoid constant tiny adjustments
      // This prevents jumping when we're already at a boundary
      if ((targetOffset - currentScroll).abs() > 1.0) {
        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final filtered = _filteredCommands;
      if (event.logicalKey.keyLabel == 'Arrow Up') {
        setState(() {
          _selectedIndex = (_selectedIndex - 1).clamp(0, filtered.length - 1);
          _scrollToSelected();
        });
      } else if (event.logicalKey.keyLabel == 'Arrow Down') {
        setState(() {
          _selectedIndex = (_selectedIndex + 1).clamp(0, filtered.length - 1);
          _scrollToSelected();
        });
      } else if (event.logicalKey.keyLabel == 'Escape') {
        _close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCommands;
    
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: _handleKeyEvent,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: _close,
          child: Container(
            color: Colors.black54,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 120),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 600,
                constraints: const BoxConstraints(maxHeight: 500),
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
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Type a command (e.g., po, svc, no, q)...',
                          hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
                          prefixIcon: Icon(
                            Icons.terminal,
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
                    if (filtered.isNotEmpty)
                      Flexible(
                        child: ListView.builder(
                          controller: _scrollController,  // Add scroll controller
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
                                  vertical: 12,
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
                                      size: 20,
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
                                            cmd.displayText,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.white.withValues(alpha: 0.87),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            cmd.description,
                                            style: const TextStyle(
                                              color: Colors.white60,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (cmd.targetTab == null && cmd.action == null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
                                        ),
                                        child: const Text(
                                          'SOON',
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    if (isSelected)
                                      const Icon(
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
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.white30,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No matching commands',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildHintKey('↑↓'),
                          const Text(' navigate  ', style: TextStyle(color: Colors.white54, fontSize: 11)),
                          _buildHintKey('Enter'),
                          const Text(' select  ', style: TextStyle(color: Colors.white54, fontSize: 11)),
                          _buildHintKey('Esc'),
                          const Text(' close', style: TextStyle(color: Colors.white54, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
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
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
    );
  }

  IconData _getCommandIcon(String name) {
    switch (name) {
      case 'pods':
        return Icons.storage_rounded;
      case 'nodes':
        return Icons.computer_rounded;
      case 'services':
        return Icons.dns_rounded;
      case 'deployments':
        return Icons.rocket_launch;
      case 'statefulsets':
        return Icons.layers;
      case 'daemonsets':
        return Icons.settings_system_daydream;
      case 'configmaps':
        return Icons.folder_outlined;
      case 'secrets':
        return Icons.lock_outline;
      case 'ingress':
        return Icons.public;
      case 'namespace':
      case 'namespaces':
        return Icons.account_tree;
      case 'persistentvolumes':
        return Icons.storage;
      case 'persistentvolumeclaims':
        return Icons.receipt_long;
      case 'cluster':
      case 'overview':
        return Icons.dashboard_rounded;
      case 'q':
      case 'quit':
        return Icons.exit_to_app;
      default:
        return Icons.terminal;
    }
  }
}

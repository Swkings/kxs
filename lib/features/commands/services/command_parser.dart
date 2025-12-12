import 'package:kxs/features/commands/models/k9s_command.dart';
import 'package:kxs/features/dashboard/controllers/dashboard_controller.dart';

/// Parses and executes k9s-style commands
class CommandParser {
  // Define all available k9s commands with their aliases
  static final List<K9sCommand> _allCommands = [
    // Resource type commands
    const K9sCommand(
      name: 'pods',
      aliases: ['po', 'pod'],
      description: 'List all pods',
      targetTab: DashboardTab.pods,
    ),
    const K9sCommand(
      name: 'services',
      aliases: ['svc', 'service'],
      description: 'List all services',
      targetTab: DashboardTab.services,
    ),
    const K9sCommand(
      name: 'nodes',
      aliases: ['no', 'node'],
      description: 'List cluster nodes',
      targetTab: DashboardTab.nodes,
    ),
    const K9sCommand(
      name: 'cluster',
      aliases: ['overview'],
      description: 'Cluster overview',
      targetTab: DashboardTab.overview,
    ),
    // Navigation commands
    K9sCommand(
      name: 'quit',
      aliases: ['q'],
      description: 'Return to home',
      action: () async {
        // Will be handled in command palette overlay
      },
    ),
    // Future commands (views not yet implemented)
    const K9sCommand(
      name: 'deployments',
      aliases: ['deploy', 'dp'],
      description: 'List deployments',
    ),
    const K9sCommand(
      name: 'statefulsets',
      aliases: ['sts'],
      description: 'List statefulsets',
    ),
    const K9sCommand(
      name: 'daemonsets',
      aliases: ['ds'],
      description: 'List daemonsets',
    ),
    const K9sCommand(
      name: 'configmaps',
      aliases: ['cm'],
      description: 'List configmaps',
    ),
    const K9sCommand(
      name: 'secrets',
      aliases: [],
      description: 'List secrets',
    ),
    const K9sCommand(
      name: 'ingress',
      aliases: ['ing'],
      description: 'List ingress resources',
    ),
    const K9sCommand(
      name: 'namespaces',
      aliases: ['ns'],
      description: 'List namespaces',
    ),
    const K9sCommand(
      name: 'persistentvolumes',
      aliases: ['pv'],
      description: 'List persistent volumes',
    ),
    const K9sCommand(
      name: 'persistentvolumeclaims',
      aliases: ['pvc'],
      description: 'List persistent volume claims',
    ),
  ];

  /// Get all available commands
  static List<K9sCommand> get allCommands => _allCommands;

  /// Parse command input and return matching command
  /// Input should start with ':' (e.g., ':po', ':pods')
  static K9sCommand? parse(String input) {
    if (input.isEmpty) return null;
    
    // Remove leading ':' if present
    final trimmed = input.trim();
    final command = trimmed.startsWith(':') 
        ? trimmed.substring(1).toLowerCase()
        : trimmed.toLowerCase();
    
    if (command.isEmpty) return null;

    // Find matching command
    try {
      return _allCommands.firstWhere(
        (cmd) => cmd.matches(command),
      );
    } catch (e) {
      return null; // No matching command found
    }
  }

  /// Get command suggestions based on partial input
  /// Returns commands that match the input prefix
  static List<K9sCommand> getSuggestions(String input) {
    if (input.isEmpty || input == ':') {
      // Return all commands if no input
      return _allCommands;
    }

    // Remove leading ':' if present
    final trimmed = input.trim();
    final search = trimmed.startsWith(':')
        ? trimmed.substring(1).toLowerCase()
        : trimmed.toLowerCase();

    if (search.isEmpty) return _allCommands;

    // Filter commands that start with the search term
    return _allCommands.where((cmd) {
      // Check if command name starts with search
      if (cmd.name.startsWith(search)) return true;
      
      // Check if any alias starts with search
      if (cmd.aliases.any((alias) => alias.startsWith(search))) return true;
      
      return false;
    }).toList();
  }

  /// Get help text for all commands
  static String getHelpText() {
    final buffer = StringBuffer();
    buffer.writeln('Available Commands:');
    buffer.writeln();
    
    for (final cmd in _allCommands) {
      buffer.write('  ${cmd.displayText.padRight(30)} ');
      buffer.writeln(cmd.description);
    }
    
    return buffer.toString();
  }
}

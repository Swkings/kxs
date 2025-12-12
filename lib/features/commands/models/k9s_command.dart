import 'package:kxs/features/dashboard/controllers/dashboard_controller.dart';

/// K9s-style command model
/// Represents a command that can be executed in the command palette
class K9sCommand {
  /// Full command name (e.g., 'pods', 'services')
  final String name;
  
  /// Command aliases/shortcuts (e.g., ['po'], ['svc'])
  final List<String> aliases;
  
  /// Description shown in help
  final String description;
  
  /// Target dashboard tab (if navigating to a view)
  final DashboardTab? targetTab;
  
  /// Custom action function (for non-navigation commands)
  final Future<void> Function()? action;

  const K9sCommand({
    required this.name,
    required this.aliases,
    required this.description,
    this.targetTab,
    this.action,
  });

  /// Check if input matches this command
  bool matches(String input) {
    final lower = input.toLowerCase();
    return name == lower || aliases.contains(lower);
  }

  /// Get display text for suggestions
  String get displayText {
    if (aliases.isEmpty) return ':$name';
    return ':$name (${aliases.map((a) => ':$a').join(', ')})';
  }
}

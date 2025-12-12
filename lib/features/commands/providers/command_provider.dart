import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'command_provider.g.dart';

/// Provider for command history
@riverpod
class CommandHistory extends _$CommandHistory {
  @override
  List<String> build() => [];

  /// Add command to history
  void add(String command) {
    if (command.isEmpty) return;
    
    // Remove if already exists (move to front)
    final newState = state.where((cmd) => cmd != command).toList();
    
    // Add to beginning and keep only last 10
    state = [command, ...newState.take(9)].toList();
  }

  /// Clear all history
 void clear() {
    state = [];
  }

  /// Get recent commands (up to limit)
  List<String> getRecent({int limit = 5}) {
    return state.take(limit).toList();
  }
}

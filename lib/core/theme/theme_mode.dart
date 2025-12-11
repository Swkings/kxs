import 'package:flutter/material.dart';

enum AppThemeMode {
  light,
  dark,
  system,
  cyberpunk,
  ocean,
}

extension AppThemeModeExtension on AppThemeMode {
  String get displayName {
    switch (this) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.cyberpunk:
        return 'Cyberpunk';
      case AppThemeMode.ocean:
        return 'Ocean';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeMode.light:
        return Icons.wb_sunny;
      case AppThemeMode.dark:
        return Icons.nightlight_round;
      case AppThemeMode.system:
        return Icons.brightness_auto;
      case AppThemeMode.cyberpunk:
        return Icons.electric_bolt;
      case AppThemeMode.ocean:
        return Icons.water;
    }
  }
}

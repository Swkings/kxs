import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kxs/core/theme/theme_mode.dart';
import 'package:kxs/core/theme/theme_provider.dart';
import 'package:kxs/l10n/app_localizations.dart';
import 'package:kxs/shared/widgets/settings_dialog.dart';

/// Global application bar with consistent styling across all views
/// Height: 40px (reduced from default 56px)
class GlobalAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String? title;

  const GlobalAppBar({
    super.key,
    this.showBackButton = false,
    this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      toolbarHeight: 40,
      elevation: 0,
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Back',
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          : null,
      actions: [
        _buildLanguageMenu(context),
        const SizedBox(width: 8),
        _buildThemeMenu(context, ref),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.settings, size: 20),
          tooltip: 'Settings',
          onPressed: () => _showSettings(context),
          padding: const EdgeInsets.all(8),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildLanguageMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, size: 20),
      tooltip: l10n.language,
      padding: const EdgeInsets.all(8),
      onSelected: (Locale locale) {
        // In a real app, use a provider to manage locale
        // For now, this is just UI demonstration
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Text(l10n.languageEnglish, style: const TextStyle(fontSize: 14)),
        ),
        PopupMenuItem(
          value: const Locale('zh'),
          child: Text(l10n.languageChinese, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildThemeMenu(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeControllerProvider);

    return PopupMenuButton<AppThemeMode>(
      icon: Icon(currentTheme.icon, size: 20),
      tooltip: 'Theme',
      padding: const EdgeInsets.all(8),
      onSelected: (AppThemeMode mode) {
        ref.read(themeControllerProvider.notifier).setTheme(mode);
      },
      itemBuilder: (context) => AppThemeMode.values.map((mode) {
        return PopupMenuItem(
          value: mode,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(mode.icon, size: 18),
              const SizedBox(width: 12),
              Text(mode.displayName, style: const TextStyle(fontSize: 14)),
              if (mode == currentTheme) ...[ 
                const SizedBox(width: 12),
                Icon(Icons.check, size: 16, color: Theme.of(context).colorScheme.primary),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const SettingsDialog(),
    );
  }
}

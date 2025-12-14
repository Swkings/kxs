import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../tokens/borders.dart';

/// 设计系统的警告框组件
class AppAlert extends StatelessWidget {
  final AlertVariant variant;
  final String? title;
  final String? message;
  final List<Widget>? actions;
  final VoidCallback? onClose;

  const AppAlert({
    super.key,
    this.variant = AlertVariant.info,
    this.title,
    this.message,
    this.actions,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = _getColorScheme();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme['background'],
        borderRadius: BorderRadius.circular(AppBorders.radiusMd),
        border: Border.all(color: colorScheme['border']!),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row with icon, title and close button
            Row(
              children: [
                Icon(
                  _getIconData(),
                  color: colorScheme['icon'],
                  size: 20,
                ),
                SizedBox(width: AppSpacing.xs),
                if (title != null) ...[
                  Expanded(
                    child: Text(
                      title!,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme['text']!,
                      ),
                    ),
                  ),
                ],
                if (onClose != null) ...[
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: AppColors.gray500,
                    ),
                    onPressed: onClose,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints.tight(Size.square(24)),
                  ),
                ],
              ],
            ),
            
            // Message
            if (message != null) ...[
              SizedBox(height: AppSpacing.xs),
              Text(
                message!,
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme['text']!,
                ),
              ),
            ],
            
            // Actions
            if (actions != null && actions!.isNotEmpty) ...[
              SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xxs,
                children: actions!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconData() {
    switch (variant) {
      case AlertVariant.success:
        return Icons.check_circle_outline;
      case AlertVariant.warning:
        return Icons.warning_amber_outlined;
      case AlertVariant.error:
        return Icons.error_outline;
      case AlertVariant.info:
      default:
        return Icons.info_outline;
    }
  }

  Map<String, Color> _getColorScheme() {
    switch (variant) {
      case AlertVariant.success:
        return {
          'background': AppColors.success.withOpacity(0.1),
          'border': AppColors.success,
          'icon': AppColors.success,
          'text': AppColors.gray900,
        };
      case AlertVariant.warning:
        return {
          'background': AppColors.warning.withOpacity(0.1),
          'border': AppColors.warning,
          'icon': AppColors.warning,
          'text': AppColors.gray900,
        };
      case AlertVariant.error:
        return {
          'background': AppColors.error.withOpacity(0.1),
          'border': AppColors.error,
          'icon': AppColors.error,
          'text': AppColors.gray900,
        };
      case AlertVariant.info:
      default:
        return {
          'background': AppColors.info.withOpacity(0.1),
          'border': AppColors.info,
          'icon': AppColors.info,
          'text': AppColors.gray900,
        };
    }
  }
}

/// 警告框变体
enum AlertVariant {
  /// 信息提示
  info,

  /// 成功提示
  success,

  /// 警告提示
  warning,

  /// 错误提示
  error,
}
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../tokens/borders.dart';

/// 设计系统的徽章组件
class AppBadge extends StatelessWidget {
  final String text;
  final BadgeVariant variant;
  final BadgeSize size;

  const AppBadge({
    super.key,
    required this.text,
    this.variant = BadgeVariant.primary,
    this.size = BadgeSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = _getColorScheme();
    final padding = _getPadding();
    final textStyle = _getTextStyle();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme['background'],
        borderRadius: BorderRadius.circular(AppBorders.radiusFull),
        border: Border.all(color: colorScheme['border']!),
      ),
      padding: padding,
      child: Text(
        text,
        style: textStyle.copyWith(color: colorScheme['text']),
      ),
    );
  }

  Map<String, Color> _getColorScheme() {
    switch (variant) {
      case BadgeVariant.primary:
        return {
          'background': AppColors.primary.withOpacity(0.1),
          'border': AppColors.primary,
          'text': AppColors.primary,
        };
      case BadgeVariant.secondary:
        return {
          'background': AppColors.gray500.withOpacity(0.1),
          'border': AppColors.gray500,
          'text': AppColors.gray700,
        };
      case BadgeVariant.success:
        return {
          'background': AppColors.success.withOpacity(0.1),
          'border': AppColors.success,
          'text': AppColors.success,
        };
      case BadgeVariant.warning:
        return {
          'background': AppColors.warning.withOpacity(0.1),
          'border': AppColors.warning,
          'text': AppColors.warning,
        };
      case BadgeVariant.error:
        return {
          'background': AppColors.error.withOpacity(0.1),
          'border': AppColors.error,
          'text': AppColors.error,
        };
      case BadgeVariant.info:
      default:
        return {
          'background': AppColors.info.withOpacity(0.1),
          'border': AppColors.info,
          'text': AppColors.info,
        };
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case BadgeSize.sm:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case BadgeSize.lg:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case BadgeSize.md:
      default:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case BadgeSize.sm:
        return AppTypography.label;
      case BadgeSize.lg:
        return AppTypography.bodyMedium;
      case BadgeSize.md:
      default:
        return AppTypography.bodySmall;
    }
  }
}

/// 徽章变体
enum BadgeVariant {
  /// 主要徽章
  primary,

  /// 次要徽章
  secondary,

  /// 信息徽章
  info,

  /// 成功徽章
  success,

  /// 警告徽章
  warning,

  /// 错误徽章
  error,
}

/// 徽章尺寸
enum BadgeSize {
  /// 小尺寸
  sm,

  /// 大尺寸
  lg,

  /// 中等尺寸
  md,
}
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../tokens/borders.dart';

/// 设计系统的工具提示组件
class AppTooltip extends StatelessWidget {
  final Widget child;
  final String message;
  final TooltipDirection direction;
  final bool disableHover;

  const AppTooltip({
    super.key,
    required this.child,
    required this.message,
    this.direction = TooltipDirection.top,
    this.disableHover = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      decoration: BoxDecoration(
        color: AppColors.gray900,
        borderRadius: BorderRadius.circular(AppBorders.radiusSm),
      ),
      textStyle: AppTypography.bodySmall.copyWith(
        color: AppColors.white,
      ),
      padding: EdgeInsets.all(AppSpacing.xs),
      preferBelow: direction == TooltipDirection.bottom,
      verticalOffset: 10,
      showDuration: disableHover ? null : const Duration(seconds: 5),
      child: child,
    );
  }
}

/// 工具提示方向
enum TooltipDirection {
  /// 向上显示
  top,

  /// 向下显示
  bottom,

  /// 向左显示
  left,

  /// 向右显示
  right,
}
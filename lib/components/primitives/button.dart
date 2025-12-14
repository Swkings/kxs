import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../tokens/borders.dart';

/// 设计系统的按钮组件
class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool disabled;
  final bool loading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.disabled = false,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled || loading;
    final buttonStyle = _getButtonStyle(context);

    if (loading) {
      return ElevatedButton(
        onPressed: null,
        style: buttonStyle,
        child: SizedBox(
          width: size == ButtonSize.small ? 16 : 20,
          height: size == ButtonSize.small ? 16 : 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              variant == ButtonVariant.primary 
                ? AppColors.white 
                : AppColors.primary,
            ),
          ),
        ),
      );
    }

    Widget buttonChild = child;
    if (icon != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: size == ButtonSize.small ? 16 : 20),
          SizedBox(width: AppSpacing.xxs),
          child,
        ],
      );
    }

    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );
      case ButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );
      case ButtonVariant.ghost:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: buttonStyle,
          child: buttonChild,
        );
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final baseStyle = ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorders.radiusMd),
        ),
      ),
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(
          horizontal: size == ButtonSize.large ? AppSpacing.lg : 
                     size == ButtonSize.medium ? AppSpacing.md : 
                     AppSpacing.sm,
          vertical: size == ButtonSize.large ? AppSpacing.sm : 
                    size == ButtonSize.medium ? AppSpacing.xs : 
                    AppSpacing.xxs,
        ),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        size == ButtonSize.large ? AppTypography.bodyLarge :
        size == ButtonSize.medium ? AppTypography.button :
        AppTypography.label,
      ),
    );

    switch (variant) {
      case ButtonVariant.primary:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.gray300;
              }
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primaryDark;
              }
              return AppColors.primary;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.gray500;
              }
              return AppColors.white;
            },
          ),
        );
      
      case ButtonVariant.secondary:
        return baseStyle.copyWith(
          side: WidgetStateProperty.resolveWith<BorderSide?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(color: AppColors.gray300);
              }
              return BorderSide(color: AppColors.primary);
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.gray500;
              }
              return AppColors.primary;
            },
          ),
        );
      
      case ButtonVariant.ghost:
        return baseStyle.copyWith(
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.gray500;
              }
              return AppColors.primary;
            },
          ),
        );
    }
  }
}

/// 按钮变体
enum ButtonVariant {
  /// 主要按钮 - 用于主要操作
  primary,

  /// 次要按钮 - 用于次要操作
  secondary,

  /// 幽灵按钮 - 用于不太重要的操作
  ghost,
}

/// 按钮尺寸
enum ButtonSize {
  /// 小尺寸
  small,

  /// 中等尺寸
  medium,

  /// 大尺寸
  large,
}
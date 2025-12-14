import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../tokens/borders.dart';
import '../tokens/shadows.dart';

/// 设计系统的卡片组件
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final BorderSide? border;
  final VoidCallback? onTap;
  final bool elevated;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.elevation,
    this.borderRadius,
    this.border,
    this.onTap,
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPadding = padding ?? EdgeInsets.all(AppSpacing.md);
    final defaultColor = color ?? AppColors.surface;
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(AppBorders.radiusLg);
    final defaultBorder = border;
    final defaultElevation = elevation ?? (elevated ? 1.0 : 0.0);

    BoxBorder? boxBorder;
    if (defaultBorder != null && defaultBorder.style != BorderStyle.none) {
      boxBorder = Border.fromBorderSide(defaultBorder);
    }

    final card = Container(
      decoration: BoxDecoration(
        color: defaultColor,
        borderRadius: defaultBorderRadius,
        border: boxBorder,
        boxShadow: elevated 
          ? [BoxShadow(
              color: AppShadows.overlay.color.withOpacity(defaultElevation * 0.1),
              offset: AppShadows.overlay.offset,
              blurRadius: AppShadows.overlay.blurRadius * (defaultElevation / 5),
              spreadRadius: AppShadows.overlay.spreadRadius,
            )]
          : null,
      ),
      child: Padding(
        padding: defaultPadding,
        child: child,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

/// 带头部的卡片组件
class AppCardWithHeader extends StatelessWidget {
  final String title;
  final Widget? subtitle;
  final List<Widget>? actions;
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final BorderSide? border;
  final VoidCallback? onTap;

  const AppCardWithHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    required this.child,
    this.padding,
    this.color,
    this.elevation,
    this.borderRadius,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      color: color,
      elevation: elevation,
      borderRadius: borderRadius,
      border: border,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: AppSpacing.xxs),
                        subtitle!,
                      ],
                    ],
                  ),
                ),
                if (actions != null) ...[
                  ...actions!.map((action) => Padding(
                    padding: EdgeInsets.only(left: AppSpacing.xs),
                    child: action,
                  )).toList(),
                ],
              ],
            ),
          ),
          
          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.gray200,
          ),
          
          // Content
          Padding(
            padding: padding ?? EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ],
      ),
    );
  }
}
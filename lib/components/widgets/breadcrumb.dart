import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';

/// 设计系统的面包屑导航组件
class AppBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final VoidCallback? onItemPressed;

  const AppBreadcrumb({
    super.key,
    required this.items,
    this.onItemPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Icon(
                Icons.chevron_right,
                size: 16,
                color: AppColors.gray400,
              ),
            ),
          ],
          if (i == items.length - 1) ...[
            // Current item (not clickable)
            Text(
              items[i].label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.gray900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ] else ...[
            // Previous items (clickable)
            GestureDetector(
              onTap: items[i].onPressed ?? onItemPressed,
              child: Text(
                items[i].label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}

/// 面包屑项
class BreadcrumbItem {
  final String label;
  final VoidCallback? onPressed;

  BreadcrumbItem({
    required this.label,
    this.onPressed,
  });
}
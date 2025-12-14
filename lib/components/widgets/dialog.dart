import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../tokens/borders.dart';
import '../tokens/shadows.dart';
import '../primitives/button.dart';

/// 设计系统的对话框组件
class AppDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final List<Widget>? actions;
  final Widget? content;
  final bool showCloseButton;

  const AppDialog({
    super.key,
    this.title,
    this.message,
    this.actions,
    this.content,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorders.radiusLg),
      ),
      elevation: 2,
      backgroundColor: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            if (title != null || showCloseButton) ...[
              Row(
                children: [
                  if (title != null) ...[
                    Expanded(
                      child: Text(
                        title!,
                        style: AppTypography.h4,
                      ),
                    ),
                  ],
                  if (showCloseButton) ...[
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.gray500,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tight(Size.square(24)),
                    ),
                  ],
                ],
              ),
              SizedBox(height: AppSpacing.sm),
            ],

            // Content
            if (content != null) ...[
              content!,
              SizedBox(height: AppSpacing.md),
            ] else if (message != null) ...[
              Text(
                message!,
                style: AppTypography.bodyMedium,
              ),
              SizedBox(height: AppSpacing.md),
            ],

            // Actions
            if (actions != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!.map((action) {
                  return Padding(
                    padding: EdgeInsets.only(left: AppSpacing.xs),
                    child: action,
                  );
                }).toList(),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
              AppButton(
                    variant: ButtonVariant.ghost,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('取消'),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  AppButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('确认'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 显示样式的对话框的便捷函数
Future<T?> showAppDialog<T>({
  required BuildContext context,
  String? title,
  String? message,
  Widget? content,
  List<Widget>? actions,
  bool showCloseButton = true,
}) {
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return AppDialog(
        title: title,
        message: message,
        content: content,
        actions: actions,
        showCloseButton: showCloseButton,
      );
    },
  );
}
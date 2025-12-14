import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../tokens/borders.dart';

/// 设计系统的下拉菜单组件
class AppDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?)? onChanged;
  final String? placeholder;
  final bool disabled;
  final Widget? label;

  const AppDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.placeholder,
    this.disabled = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final dropdown = DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: disabled ? null : onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorders.radiusMd),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorders.radiusMd),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorders.radiusMd),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),
      dropdownColor: AppColors.white,
      icon: Icon(Icons.arrow_drop_down, color: AppColors.gray500),
      hint: placeholder != null
          ? Text(
              placeholder!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.gray400,
              ),
            )
          : null,
    );

    if (label == null) {
      return dropdown;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle(
          style: AppTypography.label.copyWith(
            color: AppColors.gray700,
          ),
          child: label!,
        ),
        SizedBox(height: AppSpacing.xxs),
        dropdown,
      ],
    );
  }
}

/// 设计系统的简单下拉菜单项
class AppDropdownItem<T> extends DropdownMenuItem<T> {
  final String text;

  AppDropdownItem({
    super.value,
    required this.text,
  }) : super(
          child: Text(
            text,
            style: AppTypography.bodyMedium,
          ),
        );
}
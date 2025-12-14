import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// 设计系统的复选框组件
class AppCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  final String? label;
  final bool disabled;

  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final checkbox = Checkbox(
      value: value,
      onChanged: disabled ? null : onChanged,
      activeColor: AppColors.primary,
      checkColor: AppColors.white,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    if (label == null) {
      return checkbox;
    }

    return GestureDetector(
      onTap: disabled 
        ? null 
        : () => onChanged?.call(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: checkbox,
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            label!,
            style: AppTypography.bodyMedium.copyWith(
              color: disabled ? AppColors.gray400 : AppColors.gray900,
            ),
          ),
        ],
      ),
    );
  }
}

/// 设计系统的复选框组组件
class AppCheckboxGroup extends StatelessWidget {
  final List<CheckboxItem> items;
  final List<String> values;
  final void Function(List<String>)? onChanged;
  final bool disabled;

  const AppCheckboxGroup({
    super.key,
    required this.items,
    required this.values,
    this.onChanged,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items.map((item) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
          child: AppCheckbox(
            value: values.contains(item.value),
            onChanged: disabled 
              ? null 
              : (checked) {
                  final newValues = List<String>.from(values);
                  if (checked == true) {
                    newValues.add(item.value);
                  } else {
                    newValues.remove(item.value);
                  }
                  onChanged?.call(newValues);
                },
            label: item.label,
            disabled: disabled || item.disabled,
          ),
        );
      }).toList(),
    );
  }
}

/// 复选框项
class CheckboxItem {
  final String value;
  final String label;
  final bool disabled;

  CheckboxItem({
    required this.value,
    required this.label,
    this.disabled = false,
  });
}
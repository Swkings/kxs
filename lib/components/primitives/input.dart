import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../tokens/borders.dart';

/// 设计系统的输入框组件
class AppInput extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final String? error;
  final bool disabled;
  final bool readOnly;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final int? maxLines;
  final String? helperText;

  const AppInput({
    super.key,
    this.label,
    this.placeholder,
    this.error,
    this.disabled = false,
    this.readOnly = false,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onTap,
    this.maxLines = 1,
    this.helperText,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null && widget.error!.isNotEmpty;
    final hasLabel = widget.label != null && widget.label!.isNotEmpty;
    final hasHelper = widget.helperText != null && widget.helperText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (hasLabel) ...[
          Text(
            widget.label!,
            style: AppTypography.label.copyWith(
              color: widget.disabled ? AppColors.gray400 : AppColors.gray700,
            ),
          ),
          SizedBox(height: AppSpacing.xxs),
        ],

        // Input field
        Container(
          decoration: BoxDecoration(
            color: widget.disabled ? AppColors.gray100 : AppColors.white,
            borderRadius: BorderRadius.circular(AppBorders.radiusMd),
            border: Border.all(
              color: hasError 
                ? AppColors.error 
                : (widget.disabled ? AppColors.gray200 : AppColors.gray300),
            ),
          ),
          child: Row(
            children: [
              // Prefix
              if (widget.prefix != null) ...[
                Padding(
                  padding: EdgeInsets.only(left: AppSpacing.sm),
                  child: widget.prefix,
                ),
              ],

              // Text field
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: !widget.disabled,
                  readOnly: widget.readOnly,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText,
                  maxLines: widget.maxLines,
                  onChanged: widget.onChanged,
                  onTap: widget.onTap,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.gray400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: widget.maxLines == 1 ? AppSpacing.sm : AppSpacing.xs,
                    ),
                  ),
                  style: AppTypography.bodyMedium.copyWith(
                    color: widget.disabled ? AppColors.gray400 : AppColors.gray900,
                  ),
                ),
              ),

              // Suffix
              if (widget.suffix != null) ...[
                Padding(
                  padding: EdgeInsets.only(right: AppSpacing.sm),
                  child: widget.suffix,
                ),
              ],
            ],
          ),
        ),

        // Helper or error text
        if (hasError || hasHelper) ...[
          SizedBox(height: AppSpacing.xxs),
          Text(
            hasError ? widget.error! : widget.helperText!,
            style: AppTypography.label.copyWith(
              color: hasError ? AppColors.error : AppColors.gray500,
            ),
          ),
        ],
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../tokens/borders.dart';

/// 设计系统的进度条组件
class AppProgress extends StatelessWidget {
  final double value;
  final ProgressVariant variant;
  final double height;
  final bool animated;

  const AppProgress({
    super.key,
    required this.value,
    this.variant = ProgressVariant.primary,
    this.height = 8.0,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.gray200,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: AnimatedContainer(
            duration: animated ? const Duration(milliseconds: 300) : Duration.zero,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(height / 2),
            ),
            width: constraints.maxWidth * value.clamp(0.0, 1.0),
          ),
        );
      },
    );
  }

  Color _getColor() {
    switch (variant) {
      case ProgressVariant.primary:
        return AppColors.primary;
      case ProgressVariant.success:
        return AppColors.success;
      case ProgressVariant.warning:
        return AppColors.warning;
      case ProgressVariant.error:
        return AppColors.error;
      case ProgressVariant.info:
        return AppColors.info;
    }
  }
}

/// 设计系统的环形进度条组件
class AppCircularProgress extends StatelessWidget {
  final double value;
  final ProgressVariant variant;
  final double size;
  final double strokeWidth;

  const AppCircularProgress({
    super.key,
    required this.value,
    this.variant = ProgressVariant.primary,
    this.size = 40.0,
    this.strokeWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value.clamp(0.0, 1.0),
        strokeWidth: strokeWidth,
        backgroundColor: AppColors.gray200,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Color _getColor() {
    switch (variant) {
      case ProgressVariant.primary:
        return AppColors.primary;
      case ProgressVariant.success:
        return AppColors.success;
      case ProgressVariant.warning:
        return AppColors.warning;
      case ProgressVariant.error:
        return AppColors.error;
      case ProgressVariant.info:
        return AppColors.info;
    }
  }
}

/// 进度条变体
enum ProgressVariant {
  /// 主要进度条
  primary,

  /// 信息进度条
  info,

  /// 成功进度条
  success,

  /// 警告进度条
  warning,

  /// 错误进度条
  error,
}
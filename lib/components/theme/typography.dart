import 'package:flutter/material.dart';
import 'colors.dart';

/// 设计系统的排版系统
class AppTypography {
  /// 标题1 - 大型标题
  static TextStyle get h1 => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
        color: AppColors.gray900,
      );

  /// 标题2
  static TextStyle get h2 => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.2,
        color: AppColors.gray900,
      );

  /// 标题3
  static TextStyle get h3 => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.2,
        color: AppColors.gray900,
      );

  /// 标题4
  static TextStyle get h4 => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        height: 1.2,
        color: AppColors.gray900,
      );

  /// 标题5
  static TextStyle get h5 => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1.2,
        color: AppColors.gray900,
      );

  /// 标题6
  static TextStyle get h6 => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        height: 1.2,
        color: AppColors.gray900,
      );

  /// 正文大号字体
  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: AppColors.gray700,
      );

  /// 正文中号字体
  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: AppColors.gray700,
      );

  /// 正文小号字体
  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: AppColors.gray500,
      );

  /// 按钮文本
  static TextStyle get button => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: AppColors.gray700,
      );

  /// 标签文本
  static TextStyle get label => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: AppColors.gray600,
      );

  /// 链接文本
  static TextStyle get link => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: AppColors.primary,
        decoration: TextDecoration.underline,
      );
}

/// 文本主题扩展
extension TextThemeExtension on TextTheme {
  static TextTheme light() {
    return TextTheme(
      headlineLarge: AppTypography.h1,
      headlineMedium: AppTypography.h2,
      headlineSmall: AppTypography.h3,
      titleLarge: AppTypography.h4,
      titleMedium: AppTypography.h5,
      titleSmall: AppTypography.h6,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.button,
      labelSmall: AppTypography.label,
    );
  }
}
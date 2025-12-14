import 'package:flutter/material.dart';

/// 设计系统的颜色主题
class AppColors {
  // 主要颜色
  static const Color primary = Color(0xFF6366F1); // Indigo-500
  static const Color primaryDark = Color(0xFF4F46E5); // Indigo-600
  static const Color primaryLight = Color(0xFF818CF8); // Indigo-400
  
  // 中性色
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
  
  // 状态颜色
  static const Color success = Color(0xFF10B981); // Green-500
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color info = Color(0xFF3B82F6); // Blue-500
  
  // 背景色
  static const Color background = gray50;
  static const Color surface = white;
  static const Color overlay = Color(0x80000000); // 黑色半透明遮罩
}

/// 主题数据扩展
extension ColorSchemeExtension on ColorScheme {
  /// 获取主题的主要颜色
  static ColorScheme light() {
    return ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.gray600,
      background: AppColors.background,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onBackground: AppColors.gray900,
      onSurface: AppColors.gray900,
      onError: AppColors.white,
    );
  }
  
  /// 获取主题的暗色模式
  static ColorScheme dark() {
    return ColorScheme.dark(
      primary: AppColors.primaryLight,
      secondary: AppColors.gray400,
      background: AppColors.gray900,
      surface: AppColors.gray800,
      error: AppColors.error,
      onPrimary: AppColors.white,
      onSecondary: AppColors.black,
      onBackground: AppColors.gray100,
      onSurface: AppColors.gray100,
      onError: AppColors.white,
    );
  }
}
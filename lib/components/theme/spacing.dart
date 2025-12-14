import 'package:flutter/material.dart';

/// 设计系统的间距系统
class AppSpacing {
  /// 超小间距 - 4px
  static const double xxxs = 4.0;

  /// 超小间距 - 8px
  static const double xxs = 8.0;

  /// 小间距 - 12px
  static const double xs = 12.0;

  /// 中等间距 - 16px
  static const double sm = 16.0;

  /// 默认间距 - 20px
  static const double md = 20.0;

  /// 大间距 - 24px
  static const double lg = 24.0;

  /// 超大间距 - 32px
  static const double xl = 32.0;

  /// 超超大间距 - 40px
  static const double xxl = 40.0;

  /// 超超超大间距 - 48px
  static const double xxxl = 48.0;
}

/// EdgeInsets扩展，便于使用间距系统
extension EdgeInsetsExtension on EdgeInsets {
  /// 所有方向使用相同的间距
  static EdgeInsets all(double spacing) => EdgeInsets.all(spacing);

  /// 垂直方向间距
  static EdgeInsets vertical(double spacing) => EdgeInsets.symmetric(vertical: spacing);

  /// 水平方向间距
  static EdgeInsets horizontal(double spacing) => EdgeInsets.symmetric(horizontal: spacing);

  /// 对称间距
  static EdgeInsets symmetrical({double vertical = 0, double horizontal = 0}) =>
      EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);
}
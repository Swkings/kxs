import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// 设计系统的边框系统
class AppBorders {
  /// 无边框
  static final BorderSide none = const BorderSide(
    color: Colors.transparent,
    width: 0,
  );

  /// 轻量边框
  static final BorderSide light = BorderSide(
    color: AppColors.gray200,
    width: 1.0,
  );

  /// 默认边框
  static final BorderSide normal = BorderSide(
    color: AppColors.gray300,
    width: 1.0,
  );

  /// 强调边框
  static final BorderSide strong = BorderSide(
    color: AppColors.gray400,
    width: 1.0,
  );

  /// 圆角值 - 小
  static const double radiusSm = 4.0;

  /// 圆角值 - 中
  static const double radiusMd = 6.0;

  /// 圆角值 - 大
  static const double radiusLg = 8.0;

  /// 圆角值 - 圆形
  static const double radiusFull = 9999.0;

  /// 小圆角装饰
  static final BoxDecoration roundedSm = BoxDecoration(
    borderRadius: BorderRadius.circular(radiusSm),
  );

  /// 中圆角装饰
  static final BoxDecoration roundedMd = BoxDecoration(
    borderRadius: BorderRadius.circular(radiusMd),
  );

  /// 大圆角装饰
  static final BoxDecoration roundedLg = BoxDecoration(
    borderRadius: BorderRadius.circular(radiusLg),
  );

  /// 圆形装饰
  static final BoxDecoration roundedFull = BoxDecoration(
    borderRadius: BorderRadius.circular(radiusFull),
  );
}
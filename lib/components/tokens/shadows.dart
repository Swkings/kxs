import 'package:flutter/material.dart';

/// 设计系统的阴影系统
class AppShadows {
  /// 无阴影
  static const BoxShadow none = BoxShadow(
    color: Colors.transparent,
  );

  /// 轻量阴影
  static const BoxShadow light = BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 1),
    blurRadius: 2,
  );

  /// 中等阴影
  static const BoxShadow medium = BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 4),
    blurRadius: 6,
    spreadRadius: -1,
  );

  /// 强烈阴影
  static const BoxShadow heavy = BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 10),
    blurRadius: 15,
    spreadRadius: -3,
  );

  /// 浮层阴影
  static const BoxShadow overlay = BoxShadow(
    color: Color(0x33000000),
    offset: Offset(0, 20),
    blurRadius: 25,
    spreadRadius: -5,
  );

  /// 卡片默认阴影
  static List<BoxShadow> get card => [medium];

  /// 弹窗默认阴影
  static List<BoxShadow> get dialog => [heavy];

  /// 浮层面板默认阴影
  static List<BoxShadow> get overlayPanel => [overlay];
}
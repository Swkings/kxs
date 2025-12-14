import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../tokens/borders.dart';

/// 设计系统的头像组件
class AppAvatar extends StatelessWidget {
  final String? name;
  final String? imageUrl;
  final AvatarSize size;
  final AvatarVariant variant;
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    this.name,
    this.imageUrl,
    this.size = AvatarSize.md,
    this.variant = AvatarVariant.circle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sizeValue = _getSizeValue();
    final textStyle = _getTextStyle();

    Widget avatar = Container(
      width: sizeValue,
      height: sizeValue,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: variant == AvatarVariant.circle
            ? BorderRadius.circular(AppBorders.radiusFull)
            : BorderRadius.circular(AppBorders.radiusMd),
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null && name != null
          ? Center(
              child: Text(
                _getInitials(),
                style: textStyle,
              ),
            )
          : null,
    );

    if (onTap != null) {
      avatar = GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }

  double _getSizeValue() {
    switch (size) {
      case AvatarSize.xs:
        return 24.0;
      case AvatarSize.sm:
        return 32.0;
      case AvatarSize.md:
        return 40.0;
      case AvatarSize.lg:
        return 56.0;
      case AvatarSize.xl:
        return 80.0;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AvatarSize.xs:
        return TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        );
      case AvatarSize.sm:
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        );
      case AvatarSize.md:
        return TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        );
      case AvatarSize.lg:
        return TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        );
      case AvatarSize.xl:
        return TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        );
    }
  }

  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';
    
    final names = name!.trim().split(' ');
    if (names.isEmpty) return '?';
    
    if (names.length == 1) {
      return names[0].substring(0, 1).toUpperCase();
    } else {
      return '${names[0].substring(0, 1)}${names[names.length - 1].substring(0, 1)}'.toUpperCase();
    }
  }
}

/// 头像尺寸
enum AvatarSize {
  /// 超小 (24px)
  xs,

  /// 小 (32px)
  sm,

  /// 中 (40px)
  md,

  /// 大 (56px)
  lg,

  /// 超大 (80px)
  xl,
}

/// 头像形状
enum AvatarVariant {
  /// 圆形
  circle,

  /// 方形带圆角
  rounded,
}
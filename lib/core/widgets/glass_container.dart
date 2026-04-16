import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A frosted-glass container using BackdropFilter.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.sigmaX = 20,
    this.sigmaY = 20,
    this.color,
    this.borderTop = false,
    this.padding,
  });

  final Widget child;
  final double borderRadius;
  final double sigmaX;
  final double sigmaY;
  final Color? color;
  final bool borderTop;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? AppColors.surfaceWithOpacity60,
            borderRadius: BorderRadius.circular(borderRadius),
            border: borderTop
                ? const Border(
                    top: BorderSide(color: AppColors.border, width: 1),
                  )
                : Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          ),
          child: child,
        ),
      ),
    );
  }
}

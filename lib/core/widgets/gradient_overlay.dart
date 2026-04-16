import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Vertical linear gradient overlay, typically from transparent to background.
class GradientOverlay extends StatelessWidget {
  const GradientOverlay({
    super.key,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.colors,
    this.stops,
    this.height,
  });

  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<Color>? colors;
  final List<double>? stops;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            colors: colors ??
                const [
                  AppColors.backgroundWithOpacity0,
                  AppColors.backgroundWithOpacity80,
                  AppColors.background,
                ],
            stops: stops ?? const [0.0, 0.7, 1.0],
          ),
        ),
      ),
    );
  }
}

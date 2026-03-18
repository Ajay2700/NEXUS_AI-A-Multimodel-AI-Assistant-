// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — GlassContainer Widget
// Frosted glass morphism container
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:nexus_ai/core/theme/app_colors.dart';

/// A frosted-glass style container with blur and border effects.
///
/// Used sparingly as `BackdropFilter` is GPU-intensive.
/// Prefer [GlassContainer.light] for non-blurred glass surfaces.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.blurAmount = 20,
    this.opacity = 0.9,
    this.borderColor,
    this.borderWidth = 0.5,
    this.padding,
    this.margin,
    this.useBlur = true,
  });

  /// Glass container without BackdropFilter (cheaper rendering).
  const GlassContainer.light({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.opacity = 0.9,
    this.borderColor,
    this.borderWidth = 0.5,
    this.padding,
    this.margin,
  })  : blurAmount = 0,
        useBlur = false;

  final Widget child;
  final double borderRadius;
  final double blurAmount;
  final double opacity;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool useBlur;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.eclipse.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppColors.glassBorder,
          width: borderWidth,
        ),
      ),
      child: child,
    );

    if (!useBlur) return container;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurAmount,
          sigmaY: blurAmount,
        ),
        child: container,
      ),
    );
  }
}

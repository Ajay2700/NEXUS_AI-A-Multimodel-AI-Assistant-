// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — ShimmerLoader Widget
// Loading placeholder with shimmer animation
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:nexus_ai/core/theme/app_colors.dart';

/// A shimmer loading placeholder with NEXUS dark-theme colors.
///
/// Use for skeleton loading states when content is being fetched.
class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  /// Full-width shimmer block (e.g., for chat bubble skeletons).
  const ShimmerLoader.block({
    super.key,
    this.width = double.infinity,
    this.height = 60,
    this.borderRadius = 12,
  });

  /// Circle shimmer (e.g., for avatar).
  const ShimmerLoader.circle({
    super.key,
    required double size,
    this.borderRadius = 100,
  })  : width = size,
        height = size;

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.eclipse,
      highlightColor: AppColors.dusk,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.eclipse,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// A column of shimmer lines simulating loading text.
class ShimmerTextBlock extends StatelessWidget {
  const ShimmerTextBlock({
    super.key,
    this.lines = 3,
    this.lineHeight = 14,
    this.spacing = 10,
  });

  final int lines;
  final double lineHeight;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        // Make last line shorter for realistic look
        final isLast = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: index < lines - 1 ? spacing : 0),
          child: ShimmerLoader(
            height: lineHeight,
            width: isLast ? 120 : null,
          ),
        );
      }),
    );
  }
}

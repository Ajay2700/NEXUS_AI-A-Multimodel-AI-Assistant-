// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Waveform Visualizer Widget
// CustomPainter-based audio waveform with bar chart style
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:nexus_ai/core/theme/app_colors.dart';

/// Renders live audio amplitude data as a bar-chart waveform.
///
/// Performance: uses [RepaintBoundary] and runs at 20fps (50ms timer).
/// Only paints bars using transforms + opacity (GPU-composited).
class WaveformVisualizer extends StatelessWidget {
  const WaveformVisualizer({
    super.key,
    required this.amplitudes,
    this.barWidth = 3,
    this.barSpacing = 2,
    this.maxBars = 50,
    this.height = 80,
    this.activeColor = AppColors.nova,
    this.inactiveColor = AppColors.dusk,
  });

  final List<double> amplitudes;
  final double barWidth;
  final double barSpacing;
  final int maxBars;
  final double height;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(double.infinity, height),
        painter: _WaveformPainter(
          amplitudes: amplitudes,
          barWidth: barWidth,
          barSpacing: barSpacing,
          maxBars: maxBars,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  _WaveformPainter({
    required this.amplitudes,
    required this.barWidth,
    required this.barSpacing,
    required this.maxBars,
    required this.activeColor,
    required this.inactiveColor,
  });

  final List<double> amplitudes;
  final double barWidth;
  final double barSpacing;
  final int maxBars;
  final Color activeColor;
  final Color inactiveColor;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final totalBarWidth = barWidth + barSpacing;
    final barsToShow = math.min(amplitudes.length, maxBars);

    // Show only the last N amplitudes
    final startIndex = amplitudes.length > maxBars
        ? amplitudes.length - maxBars
        : 0;

    // Center the bars horizontally
    final totalWidth = barsToShow * totalBarWidth;
    final startX = (size.width - totalWidth) / 2;

    for (var i = 0; i < barsToShow; i++) {
      final amplitude = amplitudes[startIndex + i].clamp(0.05, 1.0);
      final barHeight = amplitude * (size.height * 0.8);
      final x = startX + (i * totalBarWidth);
      final isRecent =
          i >= barsToShow - 5; // Last 5 bars glow brighter

      final paint = Paint()
        ..color = isRecent
            ? activeColor.withValues(alpha: 0.6 + (amplitude * 0.4))
            : activeColor.withValues(alpha: 0.3 + (amplitude * 0.4))
        ..style = PaintingStyle.fill;

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x + barWidth / 2, centerY),
          width: barWidth,
          height: barHeight,
        ),
        Radius.circular(barWidth / 2),
      );

      canvas.drawRRect(rect, paint);

      // Glow effect for recent bars
      if (isRecent && amplitude > 0.3) {
        final glowPaint = Paint()
          ..color = activeColor.withValues(alpha: amplitude * 0.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawRRect(rect, glowPaint);
      }
    }

    // Draw placeholder bars if no data yet
    if (amplitudes.isEmpty) {
      final placeholderBars = (size.width / totalBarWidth).floor();
      final placeholderStart = 0.0;
      final paint = Paint()
        ..color = inactiveColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;

      for (var i = 0; i < placeholderBars; i++) {
        final barHeight = 4.0;
        final x = placeholderStart + (i * totalBarWidth);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(x + barWidth / 2, centerY),
              width: barWidth,
              height: barHeight,
            ),
            Radius.circular(barWidth / 2),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) {
    return oldDelegate.amplitudes.length != amplitudes.length ||
        (amplitudes.isNotEmpty &&
            oldDelegate.amplitudes.isNotEmpty &&
            amplitudes.last != oldDelegate.amplitudes.last);
  }
}

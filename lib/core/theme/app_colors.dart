// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — App Colors
// Tesla × Apple fusion color system
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

/// Named color constants inspired by Tesla's dark UI
/// and Apple's precision aesthetics.
abstract final class AppColors {
  // ── Background Depths ──────────────────────────────────────
  static const Color obsidian = Color(0xFF0A0A0F);
  static const Color void_ = Color(0xFF111118);
  static const Color eclipse = Color(0xFF1A1A24);
  static const Color dusk = Color(0xFF242433);

  // ── Electric Accents ───────────────────────────────────────
  static const Color plasma = Color(0xFF00E5FF);    // Primary CTA
  static const Color ion = Color(0xFF7B61FF);        // AI identity
  static const Color nova = Color(0xFF00FF94);       // Voice / success
  static const Color solar = Color(0xFFFF6B35);      // Recording / alert

  // ── Typography Colors ──────────────────────────────────────
  static const Color stark = Color(0xFFFFFFFF);      // Primary text
  static const Color mist = Color(0xFFB0B0C8);       // Secondary text
  static const Color ghost = Color(0xFF6B6B88);      // Placeholder / hint

  // ── Surface Variants ──────────────────────────────────────
  static const Color glass = Color(0xE61A1A24);      // eclipse 90% opacity
  static const Color glassBorder = Color(0x3300E5FF); // plasma 20% opacity
  static const Color glowShadow = Color(0x4D00E5FF);  // plasma 30% opacity

  // ── Gradients ──────────────────────────────────────────────
  static const LinearGradient userBubbleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ion, plasma],
  );

  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [plasma, ion, nova],
    stops: [0.0, 0.5, 1.0],
  );

  static const RadialGradient backgroundGlow = RadialGradient(
    center: Alignment.center,
    radius: 1.2,
    colors: [
      Color(0x0D7B61FF), // ion 5%
      Color(0x0500E5FF), // plasma 2%
      Colors.transparent,
    ],
    stops: [0.0, 0.4, 1.0],
  );

  // ── Semantic Colors ────────────────────────────────────────
  static const Color error = Color(0xFFFF4757);
  static const Color warning = solar;
  static const Color success = nova;
  static const Color info = plasma;
}

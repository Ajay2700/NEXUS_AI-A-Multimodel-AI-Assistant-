// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — App Root Widget
// MaterialApp.router with dark theme + GoRouter
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import 'package:nexus_ai/core/theme/theme.dart';
import 'package:nexus_ai/app/router/app_router.dart';

/// Root application widget.
///
/// Configures [MaterialApp.router] with:
/// - Dark luxury theme (Tesla × Apple fusion)
/// - GoRouter for navigation
/// - Disabled debug banner
class NexusApp extends StatelessWidget {
  const NexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NEXUS AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — App Router
// GoRouter configuration — single-screen architecture
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:nexus_ai/features/chat/presentation/pages/chat_page.dart';

/// Route path constants.
abstract final class RoutePaths {
  static const String chat = '/';
}

/// Route name constants.
abstract final class RouteNames {
  static const String chat = 'chat';
}

/// Global router configuration.
///
/// NEXUS AI is a single-screen app — the router exists for
/// extensibility and deep linking support, not navigation complexity.
final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.chat,
  debugLogDiagnostics: false,
  routes: <RouteBase>[
    GoRoute(
      path: RoutePaths.chat,
      name: RouteNames.chat,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ChatPage(),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    ),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return Scaffold(
      body: Center(
        child: Text(
          'Route not found: ${state.uri}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  },
);

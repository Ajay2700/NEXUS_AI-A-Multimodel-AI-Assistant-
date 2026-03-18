// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Logger (Talker)
// Centralized logging with Talker
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:talker_flutter/talker_flutter.dart';

/// Global Talker instance for structured logging.
///
/// Usage:
/// ```dart
/// logger.info('User sent message');
/// logger.error('WebSocket disconnected', error, stackTrace);
/// logger.debug('Token received: $token');
/// ```
final Talker logger = TalkerFlutter.init(
  settings: TalkerSettings(
    useHistory: true,
    useConsoleLogs: true,
    maxHistoryItems: 500,
  ),
);

/// Custom log for AI-specific events.
class AILog extends TalkerLog {
  AILog(
    super.message, {
    super.exception,
    super.error,
    super.stackTrace,
  });

  @override
  AnsiPen get pen => AnsiPen()..cyan();

  @override
  String get title => 'AI';
}

/// Custom log for WebSocket events.
class WebSocketLog extends TalkerLog {
  WebSocketLog(
    super.message, {
    super.exception,
    super.error,
    super.stackTrace,
  });

  @override
  AnsiPen get pen => AnsiPen()..magenta();

  @override
  String get title => 'WS';
}

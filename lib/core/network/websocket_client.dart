// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — WebSocket Client
// Manages persistent WebSocket connection for chat streaming
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:nexus_ai/core/constants/app_constants.dart';
import 'package:nexus_ai/core/utils/logger.dart';

/// Message received from the WebSocket server.
class WsMessage {
  const WsMessage({required this.type, required this.content});

  factory WsMessage.fromJson(Map<String, dynamic> json) {
    return WsMessage(
      type: json['type'] as String? ?? 'unknown',
      content: json['content'] as String? ?? '',
    );
  }

  /// `token` (streaming chunk) or `done` (stream complete) or `error`.
  final String type;

  /// The text content (token text, or error message).
  final String content;

  bool get isToken => type == 'token';
  bool get isDone => type == 'done';
  bool get isError => type == 'error';
}

/// Manages a WebSocket connection for real-time AI chat streaming.
///
/// Usage:
/// ```dart
/// final client = NexusWebSocketClient();
/// await client.connect(sessionId);
/// client.messages.listen((msg) {
///   if (msg.isToken) updateUI(msg.content);
///   if (msg.isDone) finalizeMessage();
/// });
/// client.send({'content': 'Hello', 'history': [...]});
/// ```
class NexusWebSocketClient {
  WebSocketChannel? _channel;
  StreamController<WsMessage>? _messageController;

  /// Whether the WebSocket is currently connected.
  bool get isConnected => _channel != null;

  /// Stream of parsed [WsMessage]s from the server.
  Stream<WsMessage> get messages {
    _messageController ??= StreamController<WsMessage>.broadcast();
    return _messageController!.stream;
  }

  /// Connect to the chat WebSocket endpoint.
  Future<void> connect(String sessionId) async {
    await disconnect();

    final isDesktop = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
    final wsBase = isDesktop
        ? AppConstants.desktopWsBaseUrl
        : AppConstants.wsBaseUrl;

    final uri = Uri.parse(
      '$wsBase${AppConstants.chatWsEndpoint}/$sessionId',
    );

    logger.logCustom(WebSocketLog('Connecting to $uri'));

    try {
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;
      _messageController ??= StreamController<WsMessage>.broadcast();

      _channel!.stream.listen(
        (dynamic data) {
          try {
            final jsonData = jsonDecode(data as String) as Map<String, dynamic>;
            final message = WsMessage.fromJson(jsonData);
            _messageController?.add(message);
          } catch (e, st) {
            logger.error('Failed to parse WS message', e, st);
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          logger.error('WebSocket error', error, stackTrace);
          _messageController?.addError(error, stackTrace);
        },
        onDone: () {
          logger.logCustom(WebSocketLog('Connection closed'));
          _messageController?.close();
          _channel = null;
          _messageController = null;
        },
        cancelOnError: false,
      );

      logger.logCustom(WebSocketLog('Connected successfully'));
    } catch (e, st) {
      logger.error('WebSocket connection failed', e, st);
      rethrow;
    }
  }

  /// Send a JSON-encoded message to the server.
  void send(Map<String, dynamic> data) {
    if (_channel == null) {
      logger.warning('Cannot send: WebSocket not connected');
      return;
    }
    final encoded = jsonEncode(data);
    _channel!.sink.add(encoded);
  }

  /// Disconnect and clean up resources.
  Future<void> disconnect() async {
    await _channel?.sink.close();
    await _messageController?.close();
    _channel = null;
    _messageController = null;
  }
}

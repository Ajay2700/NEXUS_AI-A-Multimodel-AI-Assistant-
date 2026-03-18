// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Chat Remote DataSource
// WebSocket + HTTP communication with backend
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';


import 'package:dio/dio.dart';


import 'package:nexus_ai/core/network/websocket_client.dart';

import 'package:nexus_ai/features/chat/domain/entities/message_entity.dart';

/// Remote data source for chat — manages WebSocket streaming and HTTP calls.
class ChatRemoteDataSource {
  ChatRemoteDataSource({
    required this.wsClient,
    required this.dio,
  });

  final NexusWebSocketClient wsClient;
  final Dio dio;

  /// Connect to the chat WebSocket for a session.
  Future<void> connect(String sessionId) async {
    await wsClient.connect(sessionId);
  }

  /// Send a message and stream response tokens.
  ///
  /// Returns a [Completer] future that resolves with the full accumulated
  /// AI response text when streaming finishes.
  Future<String> sendAndStream({
    required String content,
    required List<Map<String, dynamic>> history,
    List<String>? base64Images,
    required void Function(String token) onToken,
  }) async {
    final completer = Completer<String>();
    final buffer = StringBuffer();

    // Listen for response tokens
    StreamSubscription<WsMessage>? subscription;
    subscription = wsClient.messages.listen(
      (msg) {
        if (msg.isError) {
          // Server signalled an error explicitly
          subscription?.cancel();
          if (!completer.isCompleted) {
            completer.completeError(
              Exception('AI error: ${msg.content}'),
            );
          }
        } else if (msg.isDone) {
          // Server signalled completion
          subscription?.cancel();
          if (!completer.isCompleted) {
            completer.complete(buffer.toString());
          }
        } else {
          // Treat any non-error, non-done message as a token chunk.
          // This is more robust to backend type naming like "message"/"data".
          buffer.write(msg.content);
          onToken(msg.content);
        }
      },
      onError: (Object error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      },
      onDone: () {
        // If the socket closes without an explicit "done" message,
        // finalize with whatever we streamed so far instead of hanging.
        subscription?.cancel();
        if (!completer.isCompleted) {
          completer.complete(buffer.toString());
        }
      },
    );

    // Send the message payload
    final payload = <String, dynamic>{
      'content': content,
      'history': history,
    };

    if (base64Images != null && base64Images.isNotEmpty) {
      payload['images'] = base64Images;
    }

    wsClient.send(payload);

    return completer.future;
  }

  /// Convert message history to the format expected by the backend.
  List<Map<String, dynamic>> formatHistory(List<MessageEntity> messages) {
    return messages.map((m) {
      return {
        'role': m.role.name,
        'content': m.content,
      };
    }).toList();
  }

  /// Read an image file and convert to base64.
  Future<String> imageToBase64(String path) async {
    // This would typically read the file — handled at the repository level
    // since file I/O shouldn't be in the datasource directly.
    throw UnimplementedError('Use repository-level image encoding');
  }

  /// Disconnect the WebSocket.
  Future<void> disconnect() async {
    await wsClient.disconnect();
  }

  /// Whether the WebSocket is connected.
  bool get isConnected => wsClient.isConnected;
}

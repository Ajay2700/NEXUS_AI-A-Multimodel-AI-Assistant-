// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Chat Provider
// Riverpod notifier for chat state management
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:nexus_ai/core/error/failure.dart';
import 'package:nexus_ai/core/network/dio_client.dart';
import 'package:nexus_ai/core/network/websocket_client.dart';
import 'package:nexus_ai/core/storage/app_database.dart';
import 'package:nexus_ai/core/utils/logger.dart';
import 'package:nexus_ai/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:nexus_ai/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:nexus_ai/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:nexus_ai/features/chat/domain/entities/message_entity.dart';
import 'package:nexus_ai/features/chat/domain/repositories/chat_repository.dart';
import 'package:nexus_ai/features/chat/presentation/providers/chat_state.dart';

// ── Dependency Providers ────────────────────────────────────

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ChatRepositoryImpl(
    localDataSource: ChatLocalDataSource(database: db),
    remoteDataSource: ChatRemoteDataSource(
      wsClient: NexusWebSocketClient(),
      dio: createDioClient(),
    ),
  );
});

// ── Chat Notifier ───────────────────────────────────────────

final chatNotifierProvider =
    StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatNotifier(repository: repository);
});

/// Manages chat state — message sending, streaming, persistence.
///
/// Rules:
/// - Never expose mutable state directly
/// - All async paths have error handling
/// - Optimistic UI: user message appears instantly
class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier({required this.repository}) : super(const ChatState.initial());

  final ChatRepository repository;
  final Uuid _uuid = const Uuid();

  /// Initialize chat — load most recent conversation or create new.
  Future<void> initialize() async {
    state = const ChatState.loading();

    final conversationId = _uuid.v4();
    final result = await repository.getOrCreateConversation(conversationId);

    result.fold(
      (failure) {
        state = ChatState.error(message: failure.displayMessage);
      },
      (conversation) async {
        final messagesResult = await repository.getMessages(conversation.id);
        messagesResult.fold(
          (failure) {
            state = ChatState.error(message: failure.displayMessage);
          },
          (messages) {
            state = ChatState.loaded(
              conversation: conversation,
              messages: messages,
            );
          },
        );
      },
    );
  }

  /// Send a user message with optional image attachments.
  ///
  /// Flow:
  /// 1. Optimistic UI — add user message immediately
  /// 2. Set `isWaitingForResponse` for typing indicator
  /// 3. Stream tokens, updating `streamingContent`
  /// 4. On complete, finalize AI message in state + DB
  Future<void> sendMessage(
    String content, {
    List<String> imagePaths = const [],
  }) async {
    final currentState = state;
    if (currentState is! ChatLoaded) return;
    if (content.trim().isEmpty && imagePaths.isEmpty) return;

    // 1. Create user message entity
    final userMessage = MessageEntity(
      id: _uuid.v4(),
      conversationId: currentState.conversation.id,
      role: MessageRole.user,
      type: imagePaths.isNotEmpty ? MessageType.image : MessageType.text,
      content: content.trim(),
      status: MessageStatus.sent,
      imagePaths: imagePaths,
      createdAt: DateTime.now(),
    );

    // 2. Optimistic UI — add user message immediately
    final updatedMessages = [...currentState.messages, userMessage];
    state = currentState.copyWith(
      messages: updatedMessages,
      isWaitingForResponse: true,
      errorMessage: null,
    );

    // 3. Persist user message
    await repository.saveMessage(userMessage);

    // 4. Create streaming placeholder
    final streamingBuffer = StringBuffer();

    state = (state as ChatLoaded).copyWith(
      isStreaming: true,
      isWaitingForResponse: false,
      streamingContent: '',
    );

    // 5. Send to backend and stream response
    final result = await repository.sendMessage(
      conversationId: currentState.conversation.id,
      content: content.trim(),
      imagePaths: imagePaths,
      history: updatedMessages,
      onToken: (token) {
        streamingBuffer.write(token);
        final current = state;
        if (current is ChatLoaded) {
          state = current.copyWith(
            streamingContent: streamingBuffer.toString(),
          );
        }
      },
    );

    // 6. Finalize
    result.fold(
      (failure) {
        logger.error('Send message failed: ${failure.displayMessage}');
        final current = state;
        if (current is ChatLoaded) {
          state = current.copyWith(
            isStreaming: false,
            streamingContent: '',
            errorMessage: failure.displayMessage,
          );
        }
      },
      (aiMessage) {
        final current = state;
        if (current is ChatLoaded) {
          state = current.copyWith(
            messages: [...current.messages, aiMessage],
            isStreaming: false,
            streamingContent: '',
          );
        }
      },
    );
  }

  /// Clear current error message.
  void clearError() {
    final current = state;
    if (current is ChatLoaded) {
      state = current.copyWith(errorMessage: null);
    }
  }

  /// Start a new conversation.
  Future<void> newConversation() async {
    await initialize();
  }
}

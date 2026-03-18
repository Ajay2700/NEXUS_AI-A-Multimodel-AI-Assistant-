// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Message List Widget
// High-performance ListView.builder with auto-scroll
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import 'package:nexus_ai/core/constants/app_constants.dart';
import 'package:nexus_ai/features/chat/domain/entities/message_entity.dart';
import 'package:nexus_ai/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:nexus_ai/features/chat/presentation/widgets/typing_indicator.dart';

/// Displays the list of chat messages with auto-scroll and streaming support.
///
/// Performance:
/// - Uses [ListView.builder] (not Column in ScrollView)
/// - [ValueKey] on each message for efficient diffing
/// - Wrapped in [RepaintBoundary]
class MessageList extends StatefulWidget {
  const MessageList({
    super.key,
    required this.messages,
    this.isWaitingForResponse = false,
    this.isStreaming = false,
    this.streamingContent = '',
  });

  final List<MessageEntity> messages;
  final bool isWaitingForResponse;
  final bool isStreaming;
  final String streamingContent;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Auto-scroll on new messages or streaming content update
    if (widget.messages.length != oldWidget.messages.length ||
        widget.isStreaming != oldWidget.isStreaming ||
        widget.streamingContent != oldWidget.streamingContent) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppConstants.scrollAnimDuration,
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.messages.length +
        (widget.isWaitingForResponse ? 1 : 0) +
        (widget.isStreaming ? 1 : 0);

    return RepaintBoundary(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: totalItems,
        itemBuilder: (context, index) {
          // Regular messages
          if (index < widget.messages.length) {
            final message = widget.messages[index];
            return ChatBubble(
              key: ValueKey(message.id),
              message: message,
            );
          }

          // Typing indicator (waiting for first token)
          if (widget.isWaitingForResponse &&
              index == widget.messages.length) {
            return const TypingIndicator();
          }

          // Streaming AI message
          if (widget.isStreaming) {
            final streamingMessage = MessageEntity(
              id: 'streaming',
              conversationId: '',
              role: MessageRole.assistant,
              content: widget.streamingContent,
              createdAt: DateTime.now(),
            );
            return ChatBubble(
              key: const ValueKey('streaming-bubble'),
              message: streamingMessage,
              isStreaming: true,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

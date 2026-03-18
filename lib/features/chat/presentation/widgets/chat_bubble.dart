// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Chat Bubble Widget
// Tesla × Apple styled message bubbles for user and AI
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';

import 'dart:io';
import 'package:nexus_ai/core/theme/app_colors.dart';
import 'package:nexus_ai/core/theme/app_typography.dart';
import 'package:nexus_ai/core/utils/extensions.dart';
import 'package:nexus_ai/features/chat/domain/entities/message_entity.dart';

/// A single chat message bubble — renders differently for user vs AI.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.isStreaming = false,
  });

  final MessageEntity message;
  final bool isStreaming;

  bool get _isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment:
            _isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!_isUser) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  _isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (message.imagePaths.isNotEmpty) ...[
                  _buildImageGrid(),
                  const SizedBox(height: 8),
                ],
                _isUser ? _buildUserBubble() : _buildAIBubble(),
                const SizedBox(height: 4),
                _buildTimestamp(),
              ],
            ),
          ),
          if (_isUser) const SizedBox(width: 40),
        ],
      ),
    );
  }

  /// AI avatar dot — 28px gradient circle.
  Widget _buildAvatar() {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.logoGradient,
      ),
      child: const Icon(
        Icons.auto_awesome_rounded,
        color: AppColors.obsidian,
        size: 14,
      ),
    );
  }

  /// User message — right-aligned, gradient fill, asymmetric radius.
  Widget _buildUserBubble() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: AppColors.userBubbleGradient,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.plasma.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        message.content,
        style: AppTypography.bodyLarge.copyWith(
          color: AppColors.stark,
          height: 1.4,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    final images = message.imagePaths;
    if (images.isEmpty) return const SizedBox.shrink();

    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Wrap(
          spacing: 2,
          runSpacing: 2,
          children: images.map((path) {
            final isSingle = images.length == 1;
            return Image.file(
              File(path),
              width: isSingle ? 280 : 139,
              height: isSingle ? 200 : 139,
              fit: BoxFit.cover,
            );
          }).toList(),
        ),
      ),
    );
  }

  /// AI message — left-aligned, dark glass surface, plasma left border.
  Widget _buildAIBubble() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.eclipse,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4), // Asymmetric
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        border: const Border(
          left: BorderSide(
            color: AppColors.plasma,
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              message.content,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.mist,
                height: 1.55,
              ),
            ),
          ),
          if (isStreaming) ...[
            const SizedBox(width: 2),
            const _StreamingCursor(),
          ],
        ],
      ),
    );
  }

  /// Timestamp below each bubble.
  Widget _buildTimestamp() {
    return Padding(
      padding: EdgeInsets.only(
        left: _isUser ? 0 : 36,
        right: _isUser ? 4 : 0,
      ),
      child: Text(
        message.createdAt.timeFormatted,
        style: AppTypography.timestamp,
      ),
    );
  }
}

/// 2px blinking cursor at end of streaming AI text.
class _StreamingCursor extends StatefulWidget {
  const _StreamingCursor();

  @override
  State<_StreamingCursor> createState() => _StreamingCursorState();
}

class _StreamingCursorState extends State<_StreamingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 2,
        height: 18,
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: AppColors.plasma,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}

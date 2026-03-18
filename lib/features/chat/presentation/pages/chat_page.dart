// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Chat Page (Full Implementation)
// Single-screen AI assistant: header + messages + input dock
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nexus_ai/core/theme/app_colors.dart';
import 'package:nexus_ai/core/theme/app_typography.dart';
import 'package:nexus_ai/core/constants/app_constants.dart';
import 'package:nexus_ai/features/chat/presentation/providers/chat_provider.dart';
import 'package:nexus_ai/features/chat/presentation/providers/chat_state.dart';
import 'package:nexus_ai/features/chat/presentation/widgets/message_list.dart';
import 'package:nexus_ai/features/voice/presentation/widgets/voice_modal.dart';
import 'package:nexus_ai/features/vision/presentation/providers/vision_provider.dart';
import 'package:nexus_ai/features/vision/presentation/widgets/image_preview_strip.dart';

/// The main (and only) screen of NEXUS AI.
///
/// Layout:
/// - Transparent AppBar with NEXUS wordmark
/// - Full-height message area (Welcome or MessageList)
/// - Floating glass input dock with camera, text, mic buttons
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      final hasText = _textController.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });

    // Initialize chat on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatNotifierProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final content = _textController.text.trim();
    final visionState = ref.read(visionNotifierProvider);
    
    if (content.isEmpty && visionState.selectedImages.isEmpty) return;

    final visionNotifier = ref.read(visionNotifierProvider.notifier);
    final List<String> base64Images = await visionNotifier.getBase64Images();

    ref.read(chatNotifierProvider.notifier).sendMessage(
      content,
      imagePaths: base64Images,
    );

    _textController.clear();
    visionNotifier.clearImages();
    _focusNode.unfocus();
  }

  Future<void> _handleVoice() async {
    final transcription = await showVoiceModal(context);
    if (transcription != null && transcription.isNotEmpty) {
      _textController.text = transcription;
      setState(() => _hasText = true);
      // Optionally auto-send:
      // _handleSend();
    }
  }

  void _handleVision() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.void_,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: AppColors.plasma),
              title: Text('Gallery', style: AppTypography.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                ref.read(visionNotifierProvider.notifier).pickFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: AppColors.nova),
              title: Text('Camera', style: AppTypography.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                ref.read(visionNotifierProvider.notifier).captureFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: Stack(
        children: [
          // ── Background Glow ──────────────────────────────
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.backgroundGlow,
              ),
            ),
          ),

          // ── Main Content ─────────────────────────────────
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: chatState.when(
                    initial: () => const _WelcomeState(),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.plasma,
                        strokeWidth: 2,
                      ),
                    ),
                    loaded: (conversation, messages, isStreaming,
                        streamingContent, isWaitingForResponse,
                        errorMessage) {
                      if (messages.isEmpty && !isStreaming && !isWaitingForResponse) {
                        return const _WelcomeState();
                      }
                      return MessageList(
                        messages: messages,
                        isWaitingForResponse: isWaitingForResponse,
                        isStreaming: isStreaming,
                        streamingContent: streamingContent,
                      );
                    },
                    error: (message) => _buildErrorState(message),
                  ),
                ),
                _buildInputDock(context, chatState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: AppConstants.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            'NEXUS',
            style: AppTypography.wordmarkSmall.copyWith(letterSpacing: 4),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.plasma, AppColors.ion],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'AI',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.obsidian,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.nova,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.nova,
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              ref.read(chatNotifierProvider.notifier).newConversation();
            },
            icon: const Icon(Icons.add_rounded, color: AppColors.mist, size: 22),
            tooltip: 'New Chat',
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(36, 36),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.mist),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                ref.read(chatNotifierProvider.notifier).initialize();
              },
              child: Text('Retry',
                  style: AppTypography.buttonText
                      .copyWith(color: AppColors.plasma)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputDock(BuildContext context, ChatState chatState) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isLoaded = chatState is ChatLoaded;
    final isStreaming = isLoaded && chatState.isStreaming;

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.inputDockRadius),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 8,
              top: 12,
              bottom: 12 + bottomPadding,
            ),
            decoration: const BoxDecoration(
              color: AppColors.glass,
              border: Border(
                top: BorderSide(color: AppColors.glassBorder, width: 0.5),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image preview strip
                Consumer(
                  builder: (context, ref, child) {
                    final visionState = ref.watch(visionNotifierProvider);
                    return ImagePreviewStrip(
                      imagePaths: visionState.selectedImages,
                      onRemove: (index) => ref.read(visionNotifierProvider.notifier).removeImage(index),
                    );
                  },
                ),
                Row(
                  children: [
                    // Camera
                    _DockIconButton(
                      icon: Icons.camera_alt_rounded,
                      onPressed: isStreaming ? null : _handleVision,
                      color: AppColors.ghost,
                    ),
                    const SizedBox(width: 4),

                    // Text input
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 44, maxHeight: 120),
                        decoration: BoxDecoration(
                          color: AppColors.eclipse,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          style: AppTypography.bodyLarge,
                          maxLines: 4,
                          minLines: 1,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _handleSend(),
                          decoration: InputDecoration(
                            hintText: 'Message NEXUS...',
                            hintStyle: AppTypography.bodyMedium.copyWith(
                              color: AppColors.ghost,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Mic / Send button
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: _hasText
                          ? _DockIconButton(
                              key: const ValueKey('send'),
                              icon: Icons.arrow_upward_rounded,
                              onPressed: isStreaming ? null : _handleSend,
                              color: AppColors.plasma,
                              isAccent: true,
                            )
                          : _DockIconButton(
                              key: const ValueKey('mic'),
                              icon: Icons.mic_none_rounded,
                              onPressed: isStreaming ? null : _handleVoice,
                              color: AppColors.plasma,
                              isAccent: true,
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Welcome State ───────────────────────────────────────────

class _WelcomeState extends StatelessWidget {
  const _WelcomeState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gradient Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.logoGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.plasma.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: AppColors.ion.withValues(alpha: 0.2),
                  blurRadius: 50,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.obsidian,
              size: 36,
            ),
          ),
          const SizedBox(height: 24),
          Text('NEXUS', style: AppTypography.wordmark),
          const SizedBox(height: 12),
          Text(AppConstants.appTagline, style: AppTypography.subtitle),
          const SizedBox(height: 48),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _QuickHint(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Chat',
                color: AppColors.plasma,
              ),
              const SizedBox(width: 24),
              _QuickHint(
                icon: Icons.mic_none_rounded,
                label: 'Voice',
                color: AppColors.nova,
              ),
              const SizedBox(width: 24),
              _QuickHint(
                icon: Icons.visibility_outlined,
                label: 'Vision',
                color: AppColors.ion,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickHint extends StatelessWidget {
  const _QuickHint({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTypography.labelMedium.copyWith(color: AppColors.ghost)),
      ],
    );
  }
}

class _DockIconButton extends StatelessWidget {
  const _DockIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.color,
    this.isAccent = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;
  final bool isAccent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isAccent ? color.withValues(alpha: 0.15) : Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}

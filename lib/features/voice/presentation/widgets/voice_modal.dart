// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Voice Modal
// Bottom sheet with waveform and record button
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nexus_ai/core/theme/app_colors.dart';
import 'package:nexus_ai/core/theme/app_typography.dart';
import 'package:nexus_ai/features/voice/presentation/providers/voice_provider.dart';
import 'package:nexus_ai/features/voice/presentation/widgets/waveform_visualizer.dart';

/// Shows the voice recording modal as a bottom sheet.
Future<String?> showVoiceModal(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _VoiceModalContent(),
  );
}

class _VoiceModalContent extends ConsumerWidget {
  const _VoiceModalContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceState = ref.watch(voiceNotifierProvider);
    final notifier = ref.read(voiceNotifierProvider.notifier);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.void_,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: AppColors.glassBorder, width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.dusk,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Status text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _statusText(voiceState.status),
              style: AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          // Waveform
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 100,
              child: WaveformVisualizer(
                amplitudes: voiceState.amplitudes,
                height: 100,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Transcription preview
          if (voiceState.transcription.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.eclipse,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.glassBorder,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  voiceState.transcription,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.mist,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          if (voiceState.transcription.isNotEmpty)
            const SizedBox(height: 24),

          // Error message
          if (voiceState.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                voiceState.errorMessage!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cancel
                if (voiceState.status != VoiceStatus.idle)
                  _ActionButton(
                    icon: Icons.close_rounded,
                    color: AppColors.ghost,
                    onPressed: () async {
                      await notifier.cancel();
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),

                const SizedBox(width: 24),

                // Record / Stop button
                _RecordButton(
                  isRecording: voiceState.status == VoiceStatus.recording,
                  isProcessing: voiceState.status == VoiceStatus.transcribing,
                  onPressed: () async {
                    if (voiceState.status == VoiceStatus.idle) {
                      await notifier.startRecording();
                    } else if (voiceState.status == VoiceStatus.recording) {
                      await notifier.stopRecording();
                    }
                  },
                ),

                const SizedBox(width: 24),

                // Send transcription
                if (voiceState.status == VoiceStatus.transcribed)
                  _ActionButton(
                    icon: Icons.send_rounded,
                    color: AppColors.plasma,
                    onPressed: () {
                      Navigator.pop(context, voiceState.transcription);
                    },
                  )
                else
                  const SizedBox(width: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _statusText(VoiceStatus status) {
    switch (status) {
      case VoiceStatus.idle:
        return 'Tap to record';
      case VoiceStatus.recording:
        return 'Listening...';
      case VoiceStatus.transcribing:
        return 'Transcribing...';
      case VoiceStatus.transcribed:
        return 'Ready to send';
      case VoiceStatus.speaking:
        return 'Speaking...';
    }
  }
}

/// Circular record button with pulsing ring when active.
class _RecordButton extends StatefulWidget {
  const _RecordButton({
    required this.isRecording,
    required this.isProcessing,
    required this.onPressed,
  });

  final bool isRecording;
  final bool isProcessing;
  final VoidCallback onPressed;

  @override
  State<_RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<_RecordButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void didUpdateWidget(_RecordButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isProcessing ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final scale = 1.0 + (_pulseController.value * 0.15);
          return Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: widget.isRecording
                  ? [
                      BoxShadow(
                        color: AppColors.nova.withValues(
                          alpha: 0.3 * _pulseController.value,
                        ),
                        blurRadius: 20 * scale,
                        spreadRadius: 5 * _pulseController.value,
                      ),
                    ]
                  : null,
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isRecording
                    ? AppColors.solar
                    : AppColors.nova,
                border: Border.all(
                  color: widget.isRecording
                      ? AppColors.solar.withValues(alpha: 0.5)
                      : AppColors.nova.withValues(alpha: 0.3),
                  width: 3,
                ),
              ),
              child: widget.isProcessing
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.obsidian,
                      ),
                    )
                  : Icon(
                      widget.isRecording
                          ? Icons.stop_rounded
                          : Icons.mic_rounded,
                      color: AppColors.obsidian,
                      size: 32,
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.15),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Voice Provider
// Riverpod notifier for voice state machine
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'package:nexus_ai/core/error/failure.dart';
import 'package:nexus_ai/core/network/dio_client.dart';
import 'package:nexus_ai/core/utils/logger.dart';
import 'package:nexus_ai/features/voice/data/datasources/voice_remote_datasource.dart';
import 'package:nexus_ai/features/voice/data/repositories/voice_repository_impl.dart';
import 'package:nexus_ai/features/voice/domain/repositories/voice_repository.dart';

// ── Voice State ─────────────────────────────────────────────

enum VoiceStatus {
  idle,
  recording,
  transcribing,
  transcribed,
  speaking,
}

class VoiceState {
  const VoiceState({
    this.status = VoiceStatus.idle,
    this.amplitudes = const [],
    this.transcription = '',
    this.errorMessage,
  });

  final VoiceStatus status;
  final List<double> amplitudes;
  final String transcription;
  final String? errorMessage;

  VoiceState copyWith({
    VoiceStatus? status,
    List<double>? amplitudes,
    String? transcription,
    String? errorMessage,
  }) {
    return VoiceState(
      status: status ?? this.status,
      amplitudes: amplitudes ?? this.amplitudes,
      transcription: transcription ?? this.transcription,
      errorMessage: errorMessage,
    );
  }
}

// ── Providers ───────────────────────────────────────────────

final voiceRepositoryProvider = Provider<VoiceRepository>((ref) {
  return VoiceRepositoryImpl(
    remoteDataSource: VoiceRemoteDataSource(dio: createDioClient()),
  );
});

final voiceNotifierProvider =
    StateNotifierProvider<VoiceNotifier, VoiceState>((ref) {
  final repository = ref.watch(voiceRepositoryProvider);
  return VoiceNotifier(repository: repository);
});

// ── Voice Notifier ──────────────────────────────────────────

class VoiceNotifier extends StateNotifier<VoiceState> {
  VoiceNotifier({required this.repository}) : super(const VoiceState());

  final VoiceRepository repository;
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  Timer? _amplitudeTimer;
  String? _recordingPath;

  /// Start recording audio + sample amplitudes every 50ms.
  Future<void> startRecording() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        state = state.copyWith(
          errorMessage: 'Microphone permission denied',
        );
        return;
      }

      final tempDir = await getTemporaryDirectory();
      _recordingPath = '${tempDir.path}/nexus_recording.m4a';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _recordingPath!,
      );

      state = state.copyWith(
        status: VoiceStatus.recording,
        amplitudes: [],
        transcription: '',
      );

      // Sample amplitude every 50ms for waveform visualization
      _amplitudeTimer = Timer.periodic(
        const Duration(milliseconds: 50),
        (_) async {
          final amplitude = await _recorder.getAmplitude();
          final normalized = ((amplitude.current + 50) / 50).clamp(0.0, 1.0);
          state = state.copyWith(
            amplitudes: [...state.amplitudes, normalized],
          );
        },
      );
    } catch (e, st) {
      logger.error('Failed to start recording', e, st);
      state = state.copyWith(
        status: VoiceStatus.idle,
        errorMessage: 'Failed to start recording',
      );
    }
  }

  /// Stop recording and transcribe via Whisper.
  Future<void> stopRecording() async {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;

    try {
      final path = await _recorder.stop();
      if (path == null) {
        state = state.copyWith(status: VoiceStatus.idle);
        return;
      }

      state = state.copyWith(status: VoiceStatus.transcribing);

      final result = await repository.transcribeAudio(path);

      result.fold(
        (failure) {
          state = state.copyWith(
            status: VoiceStatus.idle,
            errorMessage: failure.displayMessage,
          );
        },
        (text) {
          state = state.copyWith(
            status: VoiceStatus.transcribed,
            transcription: text,
          );
        },
      );
    } catch (e, st) {
      logger.error('Failed to stop recording', e, st);
      state = state.copyWith(
        status: VoiceStatus.idle,
        errorMessage: 'Recording failed',
      );
    }
  }

  /// Play synthesized speech for an AI response.
  Future<void> speakText(String text) async {
    try {
      state = state.copyWith(status: VoiceStatus.speaking);

      final result = await repository.synthesizeSpeech(text);

      await result.fold(
        (failure) async {
          state = state.copyWith(
            status: VoiceStatus.idle,
            errorMessage: failure.displayMessage,
          );
        },
        (bytes) async {
          // Write audio bytes to temp file for playback
          final tempDir = await getTemporaryDirectory();
          final audioFile = File('${tempDir.path}/nexus_tts.mp3');
          await audioFile.writeAsBytes(Uint8List.fromList(bytes));

          await _player.setFilePath(audioFile.path);
          _player.playerStateStream.listen((playerState) {
            if (playerState.processingState == ProcessingState.completed) {
              state = state.copyWith(status: VoiceStatus.idle);
            }
          });
          await _player.play();
        },
      );
    } catch (e, st) {
      logger.error('TTS playback failed', e, st);
      state = state.copyWith(
        status: VoiceStatus.idle,
        errorMessage: 'Speech playback failed',
      );
    }
  }

  /// Cancel any ongoing operation and reset.
  Future<void> cancel() async {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    await _recorder.stop();
    await _player.stop();
    state = const VoiceState();
  }

  @override
  void dispose() {
    _amplitudeTimer?.cancel();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }
}

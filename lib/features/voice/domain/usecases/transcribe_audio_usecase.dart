// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Transcribe UseCase
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:fpdart/fpdart.dart';

import 'package:nexus_ai/core/error/failure.dart';
import 'package:nexus_ai/features/voice/domain/repositories/voice_repository.dart';

class TranscribeAudioUseCase {
  const TranscribeAudioUseCase({required this.repository});

  final VoiceRepository repository;

  Future<Either<Failure, String>> call(String audioPath) {
    return repository.transcribeAudio(audioPath);
  }
}

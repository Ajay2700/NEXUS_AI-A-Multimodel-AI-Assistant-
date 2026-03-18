// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Synthesize Speech UseCase
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:fpdart/fpdart.dart';

import 'package:nexus_ai/core/error/failure.dart';
import 'package:nexus_ai/features/voice/domain/repositories/voice_repository.dart';

class SynthesizeSpeechUseCase {
  const SynthesizeSpeechUseCase({required this.repository});

  final VoiceRepository repository;

  Future<Either<Failure, List<int>>> call(String text) {
    return repository.synthesizeSpeech(text);
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Voice Repository (Abstract)
// Domain contract for voice operations
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:fpdart/fpdart.dart';

import 'package:nexus_ai/core/error/failure.dart';

/// Abstract repository for voice transcription and synthesis.
abstract class VoiceRepository {
  /// Transcribe an audio file to text using Whisper.
  Future<Either<Failure, String>> transcribeAudio(String audioPath);

  /// Synthesize text to speech audio bytes.
  Future<Either<Failure, List<int>>> synthesizeSpeech(String text);
}

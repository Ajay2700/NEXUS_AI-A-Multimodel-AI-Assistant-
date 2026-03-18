// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Failure Sealed Class
// Typed error handling via Freezed
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Sealed union of all possible failure types in NEXUS AI.
///
/// Used with `Either<Failure, T>` from fpdart across all repository methods
/// to provide typed, exhaustive error handling.
@freezed
sealed class Failure with _$Failure {
  /// Network-level errors (no connectivity, timeout, DNS).
  const factory Failure.network({
    required String message,
    int? statusCode,
  }) = NetworkFailure;

  /// Server-side errors (5xx, unexpected response format).
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  /// LLM / AI pipeline errors (rate limit, context overflow, model error).
  const factory Failure.llm({
    required String message,
    String? errorCode,
  }) = LLMFailure;

  /// Voice processing errors (mic permission, recording, transcription).
  const factory Failure.voice({
    required String message,
  }) = VoiceFailure;

  /// Vision / image processing errors (camera, compression, analysis).
  const factory Failure.vision({
    required String message,
  }) = VisionFailure;

  /// Local storage errors (database, secure storage, file I/O).
  const factory Failure.storage({
    required String message,
  }) = StorageFailure;
}

/// Extension to get a user-friendly display message from any [Failure].
extension FailureX on Failure {
  String get displayMessage => when(
        network: (message, _) => 'Connection error: $message',
        server: (message, _) => 'Server error: $message',
        llm: (message, _) => 'AI error: $message',
        voice: (message) => 'Voice error: $message',
        vision: (message) => 'Vision error: $message',
        storage: (message) => 'Storage error: $message',
      );
}

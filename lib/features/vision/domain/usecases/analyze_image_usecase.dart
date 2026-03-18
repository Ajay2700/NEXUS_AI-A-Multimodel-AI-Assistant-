// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Analyze Image UseCase
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:fpdart/fpdart.dart';

import 'package:nexus_ai/core/error/failure.dart';
import 'package:nexus_ai/features/vision/domain/repositories/vision_repository.dart';

class AnalyzeImageUseCase {
  const AnalyzeImageUseCase({required this.repository});

  final VisionRepository repository;

  Future<Either<Failure, String>> call({
    required List<String> base64Images,
    String prompt = 'What do you see in this image?',
  }) {
    return repository.analyzeImage(
      base64Images: base64Images,
      prompt: prompt,
    );
  }
}

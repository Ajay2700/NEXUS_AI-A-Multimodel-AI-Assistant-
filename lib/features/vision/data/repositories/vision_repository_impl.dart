// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Vision Repository Implementation
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:fpdart/fpdart.dart';

import 'package:nexus_ai/core/error/failure.dart';
import 'package:nexus_ai/core/utils/logger.dart';
import 'package:nexus_ai/features/vision/data/datasources/vision_remote_datasource.dart';
import 'package:nexus_ai/features/vision/domain/repositories/vision_repository.dart';

class VisionRepositoryImpl implements VisionRepository {
  VisionRepositoryImpl({required this.remoteDataSource});

  final VisionRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, String>> analyzeImage({
    required List<String> base64Images,
    String? prompt,
  }) async {
    try {
      final result = await remoteDataSource.analyzeImage(
        base64Images: base64Images,
        prompt: prompt ?? 'What do you see in this image?',
      );
      return Right(result);
    } catch (e, st) {
      logger.error('Vision analysis failed', e, st);
      return Left(Failure.vision(message: e.toString()));
    }
  }
}

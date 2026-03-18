// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Voice Repository Implementation
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:fpdart/fpdart.dart';

import 'package:nexus_ai/core/error/failure.dart';
import 'package:nexus_ai/core/utils/logger.dart';
import 'package:nexus_ai/features/voice/data/datasources/voice_remote_datasource.dart';
import 'package:nexus_ai/features/voice/domain/repositories/voice_repository.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  VoiceRepositoryImpl({required this.remoteDataSource});

  final VoiceRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, String>> transcribeAudio(String audioPath) async {
    try {
      final text = await remoteDataSource.transcribeAudio(audioPath);
      return Right(text);
    } catch (e, st) {
      logger.error('Voice transcription failed', e, st);
      return Left(Failure.voice(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<int>>> synthesizeSpeech(String text) async {
    try {
      final bytes = await remoteDataSource.synthesizeSpeech(text);
      return Right(bytes);
    } catch (e, st) {
      logger.error('Speech synthesis failed', e, st);
      return Left(Failure.voice(message: e.toString()));
    }
  }
}

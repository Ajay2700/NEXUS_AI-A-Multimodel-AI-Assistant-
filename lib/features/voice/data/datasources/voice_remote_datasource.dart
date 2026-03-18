// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Voice Remote DataSource
// HTTP calls to backend for Whisper + TTS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:nexus_ai/core/constants/app_constants.dart';

/// Handles voice-related HTTP calls to the NEXUS backend.
class VoiceRemoteDataSource {
  VoiceRemoteDataSource({required this.dio});

  final Dio dio;

  /// POST audio file for Whisper transcription.
  Future<String> transcribeAudio(String audioPath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        audioPath,
        filename: 'recording.m4a',
      ),
    });

    final response = await dio.post<Map<String, dynamic>>(
      AppConstants.voiceTranscribeEndpoint,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    return response.data?['text'] as String? ?? '';
  }

  /// POST text for TTS-1-HD synthesis, returns audio bytes.
  Future<Uint8List> synthesizeSpeech(String text) async {
    final response = await dio.post<List<int>>(
      AppConstants.voiceSynthesizeEndpoint,
      data: {'text': text},
      options: Options(
        responseType: ResponseType.bytes,
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    return Uint8List.fromList(response.data ?? []);
  }
}

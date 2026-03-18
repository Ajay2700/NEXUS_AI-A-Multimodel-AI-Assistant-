// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Vision Remote DataSource
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dio/dio.dart';

import 'package:nexus_ai/core/constants/app_constants.dart';

class VisionRemoteDataSource {
  VisionRemoteDataSource({required this.dio});

  final Dio dio;

  /// POST base64 images + prompt for GPT-4o Vision analysis.
  Future<String> analyzeImage({
    required List<String> base64Images,
    String prompt = 'What do you see in this image?',
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      AppConstants.visionAnalyzeEndpoint,
      data: {
        'images': base64Images,
        'prompt': prompt,
      },
      options: Options(
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    return response.data?['analysis'] as String? ?? '';
  }
}

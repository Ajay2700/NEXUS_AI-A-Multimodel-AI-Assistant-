// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Vision Provider
// Riverpod notifier for image selection and analysis
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:nexus_ai/core/constants/app_constants.dart';
import 'package:nexus_ai/core/network/dio_client.dart';
import 'package:nexus_ai/core/utils/logger.dart';
import 'package:nexus_ai/features/vision/data/datasources/vision_remote_datasource.dart';
import 'package:nexus_ai/features/vision/data/repositories/vision_repository_impl.dart';
import 'package:nexus_ai/features/vision/domain/repositories/vision_repository.dart';

// ── Vision State ────────────────────────────────────────────

class VisionState {
  const VisionState({
    this.selectedImages = const [],
    this.isAnalyzing = false,
    this.errorMessage,
  });

  /// Local file paths of selected images.
  final List<String> selectedImages;
  final bool isAnalyzing;
  final String? errorMessage;

  VisionState copyWith({
    List<String>? selectedImages,
    bool? isAnalyzing,
    String? errorMessage,
  }) {
    return VisionState(
      selectedImages: selectedImages ?? this.selectedImages,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      errorMessage: errorMessage,
    );
  }
}

// ── Providers ───────────────────────────────────────────────

final visionRepositoryProvider = Provider<VisionRepository>((ref) {
  return VisionRepositoryImpl(
    remoteDataSource: VisionRemoteDataSource(dio: createDioClient()),
  );
});

final visionNotifierProvider =
    StateNotifierProvider<VisionNotifier, VisionState>((ref) {
  final repository = ref.watch(visionRepositoryProvider);
  return VisionNotifier(repository: repository);
});

// ── Vision Notifier ─────────────────────────────────────────

class VisionNotifier extends StateNotifier<VisionState> {
  VisionNotifier({required this.repository}) : super(const VisionState());

  final VisionRepository repository;
  final ImagePicker _picker = ImagePicker();

  /// Pick images from gallery (multi-select).
  Future<void> pickFromGallery() async {
    try {
      final images = await _picker.pickMultiImage(
        imageQuality: AppConstants.imageQuality,
        maxWidth: AppConstants.imageMaxDimension.toDouble(),
        maxHeight: AppConstants.imageMaxDimension.toDouble(),
      );

      if (images.isEmpty) return;

      // Limit to max attachments
      final total = state.selectedImages.length + images.length;
      final toAdd = total > AppConstants.maxImageAttachments
          ? images.take(AppConstants.maxImageAttachments - state.selectedImages.length).toList()
          : images;

      final paths = toAdd.map((x) => x.path).toList();
      state = state.copyWith(
        selectedImages: [...state.selectedImages, ...paths],
      );
    } catch (e, st) {
      logger.error('Image pick failed', e, st);
      state = state.copyWith(errorMessage: 'Failed to select images');
    }
  }

  /// Capture image from camera.
  Future<void> captureFromCamera() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: AppConstants.imageQuality,
        maxWidth: AppConstants.imageMaxDimension.toDouble(),
        maxHeight: AppConstants.imageMaxDimension.toDouble(),
      );

      if (image == null) return;

      if (state.selectedImages.length >= AppConstants.maxImageAttachments) {
        state = state.copyWith(
          errorMessage: 'Maximum ${AppConstants.maxImageAttachments} images allowed',
        );
        return;
      }

      state = state.copyWith(
        selectedImages: [...state.selectedImages, image.path],
      );
    } catch (e, st) {
      logger.error('Camera capture failed', e, st);
      state = state.copyWith(errorMessage: 'Failed to capture image');
    }
  }

  /// Remove an image at index.
  void removeImage(int index) {
    final images = [...state.selectedImages];
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      state = state.copyWith(selectedImages: images);
    }
  }

  /// Clear all selected images.
  void clearImages() {
    state = state.copyWith(selectedImages: []);
  }

  /// Compress and encode all selected images to base64.
  Future<List<String>> getBase64Images() async {
    final base64List = <String>[];

    for (final path in state.selectedImages) {
      try {
        // Compress
        final compressed = await FlutterImageCompress.compressWithFile(
          path,
          quality: AppConstants.imageQuality,
          minWidth: AppConstants.imageMaxDimension,
          minHeight: AppConstants.imageMaxDimension,
        );

        if (compressed != null) {
          base64List.add(base64Encode(compressed));
        } else {
          // Fallback: read original
          final bytes = await File(path).readAsBytes();
          base64List.add(base64Encode(bytes));
        }
      } catch (e) {
        logger.error('Failed to compress image: $path', e);
        final bytes = await File(path).readAsBytes();
        base64List.add(base64Encode(bytes));
      }
    }

    return base64List;
  }
}

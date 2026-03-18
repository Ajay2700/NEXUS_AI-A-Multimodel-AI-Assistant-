// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Image Preview Strip Widget
// Horizontal scrolling thumbnails above input dock
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:nexus_ai/core/theme/app_colors.dart';

/// Horizontal strip of image thumbnails with remove buttons.
class ImagePreviewStrip extends StatelessWidget {
  const ImagePreviewStrip({
    super.key,
    required this.imagePaths,
    required this.onRemove,
  });

  final List<String> imagePaths;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _ImageThumbnail(
              path: imagePaths[index],
              onRemove: () => onRemove(index),
            ),
          );
        },
      ),
    );
  }
}

class _ImageThumbnail extends StatelessWidget {
  const _ImageThumbnail({
    required this.path,
    required this.onRemove,
  });

  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(path),
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.eclipse,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.broken_image_outlined,
                color: AppColors.ghost,
                size: 24,
              ),
            ),
          ),
        ),

        // Remove button
        Positioned(
          top: 2,
          right: 2,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.obsidian.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.stark,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

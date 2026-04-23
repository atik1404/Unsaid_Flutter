import 'dart:io';
import 'package:ui/src/utils/image/image_constant.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

final class ImageRepository {
  ImageRepository();

  Future<Directory> _appImagesDir() async {
    final cache = await getTemporaryDirectory();
    final dir = Directory(path.join(cache.path, 'app_images'));
    if (!await dir.exists()) await dir.create(recursive: true);

    return dir;
  }

  Future<File> _moveOrCopy(File src, String destPath) async {
    try {
      return await src.rename(destPath); // fast path (same volume)
    } catch (_) {
      return src.copy(destPath); // fallback across volumes
    }
  }

  /// Compresses the given image file to ensure its size is under 1MB.
  /// Uses iterative compression by reducing quality and dimensions.
  /// Returns the compressed file if successful, or null if compression fails.
  Future<File?> compressToUnder300Kb(File inputImageFile) async {
    final dir = await _appImagesDir();
    final outPath = path.join(
      dir.path,
      'img_${DateTime.now().microsecondsSinceEpoch}_${path.basename(inputImageFile.path)}',
    );

    if (await _isImageBelow300Kb(inputImageFile)) {
      final inputMovedFile = await _moveOrCopy(inputImageFile, outPath);
      // Optionally delete original if it still exists and we copied:
      if (inputImageFile.path != inputMovedFile.path) {
        try {
          await inputImageFile.delete();
        } catch (_) {}
      }

      return inputMovedFile;
    }

    for (var attempt = 1; attempt < 8; attempt++) {
      final compressedXFile = await FlutterImageCompress.compressAndGetFile(
        inputImageFile.path,
        outPath,
        quality: imageQuality - attempt * 5,
        minWidth: imageMaxWidth.toInt() - attempt * 100,
        minHeight: imageMaxHeight.toInt() - attempt * 45,
        autoCorrectionAngle: true,
        keepExif: false,
      );

      if (compressedXFile == null) {
        try {
          await File(outPath).delete();
        } catch (_) {}

        return null;
      }

      final compressedFile = File(compressedXFile.path);
      if (await _isImageBelow300Kb(compressedFile)) {
        // Success: delete original temp if it still exists & differs
        if (inputImageFile.path != compressedFile.path) {
          try {
            await inputImageFile.delete();
          } catch (_) {}
        }

        return compressedFile;
      }
    }

    return null;
  }

  Future<File?> shrinkImage(
    File inputImageFile, {
    int? quality,
    int? minWidth,
    int? minHeight,
  }) async {
    final dir = await _appImagesDir();
    final outPath = path.join(
      dir.path,
      'img_${DateTime.now().microsecondsSinceEpoch}_${path.basename(inputImageFile.path)}',
    );

    final inputMovedFile = await _moveOrCopy(inputImageFile, outPath);
    // Optionally delete original if it still exists and we copied:
    if (inputImageFile.path != inputMovedFile.path) {
      try {
        await inputImageFile.delete();
      } catch (_) {}
    }

    final outPathCompressed = path.join(
      dir.path,
      'img_${DateTime.now().microsecondsSinceEpoch}_compressed_${path.basename(inputImageFile.path)}',
    );

    final compressedXFile = await FlutterImageCompress.compressAndGetFile(
      inputMovedFile.path,
      outPathCompressed,
      quality: quality ?? imageQuality,
      minWidth: minWidth ?? imageMaxWidth.toInt(),
      minHeight: minHeight ?? imageMaxHeight.toInt(),
    );

    if (compressedXFile == null) {
      try {
        await File(outPath).delete();
        await File(outPathCompressed).delete();
      } catch (_) {}

      return null;
    }

    final compressedFile = File(compressedXFile.path);
    // Success: delete original temp if it still exists & differs
    if (inputMovedFile.path != compressedFile.path) {
      try {
        await inputMovedFile.delete();
      } catch (_) {}
    }

    return compressedFile;
  }

  /// Checks if the given image file is below 300 KB in size.
  /// Returns true if the file size is within the limit, false otherwise.
  Future<bool> _isImageBelow300Kb(File imageFile) async =>
      (await imageFile.length()) <= 300 * 1024;

  /// Removes the photo at the specified index from the state and deletes the file.
  /// If the index is invalid or the file does not exist, no action is taken.
  Future<bool> delete(File imageFile) async {
    if (await imageFile.exists()) {
      await imageFile.delete();

      return true;
    } else {
      return false;
    }
  }

  /// Clears the entire app_images cache directory.
  Future<void> clearAppImagesDir() async {
    try {
      final dir = await _appImagesDir();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {}
  }
}

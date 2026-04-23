import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ui/src/utils/image/image_repository.dart';

/// A utility class for picking images from gallery
class ImageUtils {
  static final ImagePicker _picker = ImagePicker();

  static final ImageRepository _imageRepository = ImageRepository();

  /// Max file size in bytes, default 300 KB
  static const int _maxFileSize = 300 * 1024;

  /// Picks an image from gallery and returns [ImagePickResult]
  static Future<ImagePickResult> pickImageToBase64({int? maxFileSize}) async {
    final effectiveMaxSize = maxFileSize ?? _maxFileSize;

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        return const ImagePickResult.noImage();
      }

      final capturedFile = File(pickedFile.path);

      final compressedFile = await _imageRepository.compressToUnder300Kb(
        capturedFile,
      );
      if (compressedFile == null) {
        // Failed to compress
        return const ImagePickResult.noImage();
      }

      final bytes = await compressedFile.readAsBytes();

      if (bytes.length > effectiveMaxSize) {
        return ImagePickResult.tooLarge(
          'Image size should be max ${effectiveMaxSize ~/ 1024} KB',
        );
      }

      final base64Image = base64Encode(bytes);

      return ImagePickResult.success(base64Image);
    } catch (e) {
      return ImagePickResult.error('Something went wrong while picking image');
    }
  }
}

/// Sealed class for representing image pick results
sealed class ImagePickResult {
  const ImagePickResult();

  factory ImagePickResult.success(String base64) = ImagePickSuccess._;
  factory ImagePickResult.error(String message) = ImagePickError._;
  factory ImagePickResult.tooLarge(String message) = ImagePickTooLarge._;
  const factory ImagePickResult.noImage() = ImagePickNoImage._;

  bool get isSuccess => this is ImagePickSuccess;
}

/// Represents a successful image pick
final class ImagePickSuccess extends ImagePickResult {
  final String base64Image;
  const ImagePickSuccess._(this.base64Image);
}

/// Represents a generic error
final class ImagePickError extends ImagePickResult {
  final String message;
  const ImagePickError._(this.message);
}

/// Represents an error when image is too large
final class ImagePickTooLarge extends ImagePickResult {
  final String message;
  const ImagePickTooLarge._(this.message);
}

/// Represents when user cancels image selection
final class ImagePickNoImage extends ImagePickResult {
  const ImagePickNoImage._();
}

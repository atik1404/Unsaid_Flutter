import 'dart:io';

class ImageCaptureState {
  final List<File> pictures;
  final bool capturing;

  const ImageCaptureState({
    this.pictures = const [],
    this.capturing = false,
  });

  ImageCaptureState copyWith({
    List<File>? pictures,
    bool? capturing,
  }) {
    return ImageCaptureState(
      pictures: pictures ?? this.pictures,
      capturing: capturing ?? this.capturing,
    );
  }
}

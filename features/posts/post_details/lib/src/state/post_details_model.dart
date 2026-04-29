import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_details_model.freezed.dart';

/// Data model for a post displayed on the Post Details screen.
///
/// This is self-contained within the post_details package to avoid
/// coupling with the home package's model.
@freezed
abstract class PostDetailsModel with _$PostDetailsModel {
  const factory PostDetailsModel({
    required String id,
    required String title,
    required DateTime dateTime,
    required String description,
    required String tag,
    @Default('Anonymous') String author,
  }) = _PostDetailsModel;
}

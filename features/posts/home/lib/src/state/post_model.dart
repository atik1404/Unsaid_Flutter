import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';

@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String title,
    required DateTime dateTime,
    required String description,
    required String tag,
  }) = _PostModel;
}

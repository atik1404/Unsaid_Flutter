import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_post_model.freezed.dart';

/// A lightweight model representing a post authored by the profile owner.
///
/// This is intentionally separate from the home feature's [PostModel]
/// to keep packages decoupled.
@freezed
abstract class ProfilePostModel with _$ProfilePostModel {
  const factory ProfilePostModel({
    required String id,
    required String title,
    required DateTime dateTime,
    required String description,
    required String tag,
  }) = _ProfilePostModel;
}

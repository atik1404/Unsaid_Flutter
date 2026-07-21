import 'package:json_annotation/json_annotation.dart';

part 'update_profile_dto.g.dart';

/// Response payload for the `PATCH /profile` endpoint.
///
/// Only the human-readable [message] is surfaced to the domain layer; the
/// refreshed profile is re-fetched separately after a successful update.
@JsonSerializable(createToJson: false)
final class UpdateProfileDto {
  @JsonKey(name: 'status_code')
  final int? statusCode;
  final String? message;

  UpdateProfileDto({
    this.statusCode,
    this.message,
  });

  factory UpdateProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileDtoFromJson(json);
}

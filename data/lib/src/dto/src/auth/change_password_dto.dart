import 'package:json_annotation/json_annotation.dart';

part 'change_password_dto.g.dart';

/// Response payload for the `auth/change-password` endpoint.
///
/// Only the human-readable [message] is surfaced to the domain layer.
@JsonSerializable(createToJson: false)
final class ChangePasswordDto {
  @JsonKey(name: 'status_code')
  final int? statusCode;
  final String? message;

  ChangePasswordDto({
    this.statusCode,
    this.message,
  });

  factory ChangePasswordDto.fromJson(Map<String, dynamic> json) => _$ChangePasswordDtoFromJson(json);
}

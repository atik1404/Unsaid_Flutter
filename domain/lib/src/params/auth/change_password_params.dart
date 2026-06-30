import 'package:json_annotation/json_annotation.dart';

part 'change_password_params.g.dart';

/// Request payload for the `auth/change-password` endpoint.
///
/// Serialized to the snake_case keys the API expects
/// (`old_password`, `new_password`, `confirm_password`).
@JsonSerializable(createFactory: false)
final class ChangePasswordParams {
  @JsonKey(name: 'old_password')
  final String oldPassword;
  @JsonKey(name: 'new_password')
  final String newPassword;
  @JsonKey(name: 'confirm_password')
  final String confirmPassword;

  const ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => _$ChangePasswordParamsToJson(this);
}

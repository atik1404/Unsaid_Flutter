import 'package:json_annotation/json_annotation.dart';

part 'signup_dto.g.dart';

@JsonSerializable(createToJson: false)
class SignupDto {
  final String? message;
  @JsonKey(name: 'auth_token')
  final String? authToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @JsonKey(name: 'expiration_date')
  final String? expirationDate;
  final int? statusCode;

  const SignupDto({this.message, this.authToken, this.refreshToken, this.expirationDate, this.statusCode});

  factory SignupDto.fromJson(Map<String, dynamic> json) => _$SignupDtoFromJson(json);
}

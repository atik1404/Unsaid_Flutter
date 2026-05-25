import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

@JsonSerializable(createToJson: false)
class LoginDto {
  final String? message;
  @JsonKey(name: 'auth_token')
  final String? authToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @JsonKey(name: 'expiration_date')
  final String? expirationDate;
  @JsonKey(name: 'status_code')
  final int? statusCode;

  const LoginDto({this.message, this.authToken, this.refreshToken, this.expirationDate, this.statusCode});

  factory LoginDto.fromJson(Map<String, dynamic> json) => _$LoginDtoFromJson(json);
}

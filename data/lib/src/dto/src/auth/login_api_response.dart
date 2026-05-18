import 'package:json_annotation/json_annotation.dart';

part 'login_api_response.g.dart';

@JsonSerializable(createToJson: false)
class LoginApiResponse {
  final String? message;
  @JsonKey(name: 'auth_token')
  final String? authToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @JsonKey(name: 'expiration_date')
  final String? expirationDate;
  @JsonKey(name: 'status_code')
  final int? statusCode;

  const LoginApiResponse({this.message, this.authToken, this.refreshToken, this.expirationDate, this.statusCode});

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) => _$LoginApiResponseFromJson(json);
}

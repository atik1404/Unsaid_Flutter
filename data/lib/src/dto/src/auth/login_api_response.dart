import 'package:json_annotation/json_annotation.dart';

part 'login_api_response.g.dart';

@JsonSerializable(createToJson: false)
class LoginApiResponse {
  final LoginApiData? data;
  final String? message;
  final int? statusCode;

  const LoginApiResponse({this.data, this.message, this.statusCode});

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) => _$LoginApiResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class LoginApiData {
  final String? accessToken;
  final String? refreshToken;

  const LoginApiData({this.accessToken, this.refreshToken});

  factory LoginApiData.fromJson(Map<String, dynamic> json) => _$LoginApiDataFromJson(json);
}

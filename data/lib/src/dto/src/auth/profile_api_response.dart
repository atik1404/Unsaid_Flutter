import 'package:json_annotation/json_annotation.dart';

part 'profile_api_response.g.dart';

@JsonSerializable(createToJson: false)
class ProfileApiResponse {
  final ProfileApiData? data;
  final String? message;
  final int? statusCode;

  const ProfileApiResponse({this.data, this.message, this.statusCode});

  factory ProfileApiResponse.fromJson(Map<String, dynamic> json) => _$ProfileApiResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class ProfileApiData {
  final String? id;
  final String? name;
  final String? avatar;
  final String? phone;
  final String? secondaryPhone;
  final String? email;

  const ProfileApiData({this.id, this.name, this.avatar, this.phone, this.secondaryPhone, this.email});

  factory ProfileApiData.fromJson(Map<String, dynamic> json) => _$ProfileApiDataFromJson(json);
}

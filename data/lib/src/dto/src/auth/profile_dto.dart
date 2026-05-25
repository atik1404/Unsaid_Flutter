import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

@JsonSerializable(createToJson: false)
class ProfileDto {
  final ProfileData? data;
  final String? message;
  final int? statusCode;

  const ProfileDto({this.data, this.message, this.statusCode});

  factory ProfileDto.fromJson(Map<String, dynamic> json) => _$ProfileDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class ProfileData {
  final String? id;
  final String? name;
  final String? avatar;
  final String? phone;
  final String? secondaryPhone;
  final String? email;

  const ProfileData({this.id, this.name, this.avatar, this.phone, this.secondaryPhone, this.email});

  factory ProfileData.fromJson(Map<String, dynamic> json) => _$ProfileDataFromJson(json);
}

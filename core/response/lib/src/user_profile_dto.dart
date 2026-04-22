import 'package:json_annotation/json_annotation.dart';

part 'user_profile_dto.g.dart';

@JsonSerializable(
  createFactory: true,
  createToJson: false,
)
final class UserProfileDto {
  final String? name;
  final String? email;

  UserProfileDto({
    required this.name,
    required this.email,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);
}

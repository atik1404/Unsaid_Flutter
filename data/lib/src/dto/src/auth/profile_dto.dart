import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

@JsonSerializable(createToJson: false)
class ProfileDto {
  final String? id;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'last_seen_at')
  final String? lastSeenAt;
  final String? status;
  @JsonKey(name: 'is_verified')
  final bool? isVerified;
  final int? reputation;
  @JsonKey(name: 'avatar_seed')
  final int? avatarSeed;
  @JsonKey(name: 'anonymous_tag')
  final String? anonymousTag;
  @JsonKey(name: 'user_identity')
  final UserIdentityDto? userIdentity;
  @JsonKey(name: 'post_count')
  final int? postCount;

  const ProfileDto({
    this.id,
    this.createdAt,
    this.lastSeenAt,
    this.status,
    this.isVerified,
    this.reputation,
    this.avatarSeed,
    this.anonymousTag,
    this.userIdentity,
    this.postCount,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) => _$ProfileDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class UserIdentityDto {
  @JsonKey(name: 'full_name')
  final String? fullName;
  final String? email;
  @JsonKey(name: 'phone_e164')
  final String? phoneE164;
  final String? bio;
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;
  @JsonKey(name: 'address_line1')
  final String? addressLine1;
  @JsonKey(name: 'address_line2')
  final String? addressLine2;
  final String? city;
  final String? state;
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  final String? country;

  const UserIdentityDto({
    this.fullName,
    this.email,
    this.phoneE164,
    this.bio,
    this.dateOfBirth,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
  });

  factory UserIdentityDto.fromJson(Map<String, dynamic> json) => _$UserIdentityDtoFromJson(json);
}

import 'package:data/src/dto/dto.dart';
import 'package:entity/entity.dart';

extension ProfileApiMapper on ProfileDto {
  ProfileEntity toEntity() => ProfileEntity(
    id: id ?? '',
    createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
    lastSeenAt: lastSeenAt != null ? DateTime.tryParse(lastSeenAt!) : null,
    status: status ?? '',
    isVerified: isVerified ?? false,
    reputation: reputation ?? 0,
    avatarSeed: avatarSeed ?? 0,
    anonymousTag: anonymousTag ?? '',
    identity:
        userIdentity?.toEntity() ??
        const UserIdentityEntity(
          fullName: '',
          email: '',
          phoneE164: '',
          addressLine1: '',
          city: '',
          state: '',
          postalCode: '',
          country: '',
        ),
    postCount: postCount ?? 0,
  );
}

extension _UserIdentityMapper on UserIdentityDto {
  UserIdentityEntity toEntity() => UserIdentityEntity(
    fullName: fullName ?? '',
    email: email ?? '',
    phoneE164: phoneE164 ?? '',
    dateOfBirth: dateOfBirth != null ? DateTime.tryParse(dateOfBirth!) : null,
    addressLine1: addressLine1 ?? '',
    addressLine2: addressLine2,
    city: city ?? '',
    state: state ?? '',
    postalCode: postalCode ?? '',
    country: country ?? '',
  );
}

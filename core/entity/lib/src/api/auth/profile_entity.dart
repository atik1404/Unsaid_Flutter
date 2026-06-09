final class ProfileEntity {
  final String id;
  final DateTime createdAt;
  final DateTime? lastSeenAt;
  final String status;
  final bool isVerified;
  final int reputation;
  final int avatarSeed;
  final String anonymousTag;
  final UserIdentityEntity identity;
  final int postCount;

  const ProfileEntity({
    required this.id,
    required this.createdAt,
    this.lastSeenAt,
    required this.status,
    required this.isVerified,
    required this.reputation,
    required this.avatarSeed,
    required this.anonymousTag,
    required this.identity,
    required this.postCount,
  });

  /// Used by [AuthRepoImpl] to persist the display name locally.
  String get name => identity.fullName;

  /// Used by [AuthRepoImpl] to persist the email locally.
  String get email => identity.email;
}

final class UserIdentityEntity {
  final String fullName;
  final String email;
  final String phoneE164;
  final DateTime? dateOfBirth;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  const UserIdentityEntity({
    required this.fullName,
    required this.email,
    required this.phoneE164,
    this.dateOfBirth,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });
}

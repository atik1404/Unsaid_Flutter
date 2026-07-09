import 'package:data/src/dto/src/auth/update_profile_dto.dart';

/// Maps an [UpdateProfileDto] to its domain representation — the success
/// message string. Falls back to an empty string when absent.
extension UpdateProfileApiMapper on UpdateProfileDto {
  String toEntity() => message ?? '';
}

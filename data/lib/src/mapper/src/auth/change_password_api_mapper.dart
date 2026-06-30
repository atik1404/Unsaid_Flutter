import 'package:data/src/dto/src/auth/change_password_dto.dart';

/// Maps a [ChangePasswordDto] to its domain representation — the success
/// message string. Falls back to an empty string when absent.
extension ChangePasswordApiMapper on ChangePasswordDto {
  String toEntity() => message ?? '';
}

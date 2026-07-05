import 'package:data/src/dto/src/auth/delete_account_dto.dart';

/// Maps a [DeleteAccountDto] to its domain representation — the success
/// message string. Falls back to an empty string when absent.
extension DeleteAccountApiMapper on DeleteAccountDto {
  String toEntity() => message ?? '';
}

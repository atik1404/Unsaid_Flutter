import 'package:data/src/dto/src/common/delete_response_dto.dart';

/// Maps a [DeleteResponseDto] to its domain representation — the success
/// message string. Falls back to an empty string when absent.
extension DeleteResponseApiMapper on DeleteResponseDto {
  String toEntity() => message ?? '';
}

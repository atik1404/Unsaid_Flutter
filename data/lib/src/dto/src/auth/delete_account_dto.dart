import 'package:json_annotation/json_annotation.dart';

part 'delete_account_dto.g.dart';

/// Response payload for the `DELETE /profile` (delete account) endpoint.
///
/// Only the human-readable [message] is surfaced to the domain layer; the
/// `data.user_id` field is intentionally ignored.
@JsonSerializable(createToJson: false)
final class DeleteAccountDto {
  @JsonKey(name: 'status_code')
  final int? statusCode;
  final String? message;

  DeleteAccountDto({
    this.statusCode,
    this.message,
  });

  factory DeleteAccountDto.fromJson(Map<String, dynamic> json) => _$DeleteAccountDtoFromJson(json);
}

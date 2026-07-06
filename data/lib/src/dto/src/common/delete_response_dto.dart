import 'package:json_annotation/json_annotation.dart';

part 'delete_response_dto.g.dart';

/// Shared response payload for destructive `DELETE` endpoints (e.g. delete
/// account, delete all posts).
///
/// These endpoints share the same envelope — `status_code`, a human-readable
/// [message], and a `data` object whose contents differ per endpoint and are
/// intentionally ignored. Only the [message] is surfaced to the domain layer.
@JsonSerializable(createToJson: false)
final class DeleteResponseDto {
  @JsonKey(name: 'status_code')
  final int? statusCode;
  final String? message;

  DeleteResponseDto({
    this.statusCode,
    this.message,
  });

  factory DeleteResponseDto.fromJson(Map<String, dynamic> json) => _$DeleteResponseDtoFromJson(json);
}

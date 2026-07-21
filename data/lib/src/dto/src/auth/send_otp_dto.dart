import 'package:json_annotation/json_annotation.dart';

part 'send_otp_dto.g.dart';

@JsonSerializable(createToJson: false)
final class SendOtpDto {
  @JsonKey(name: 'status_code')
  final int? statusCode;
  final String? message;
  @JsonKey(name: 'account_id')
  final String? accountId;
  @JsonKey(name: 'message_id')
  final String? messageId;

  SendOtpDto({
    this.statusCode,
    this.message,
    this.accountId,
    this.messageId,
  });

  factory SendOtpDto.fromJson(Map<String, dynamic> json) =>
      _$SendOtpDtoFromJson(json);
}

import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_dto.g.dart';

@JsonSerializable(createToJson: false)
final class VerifyOtpDto {
  @JsonKey(name: 'status_code')
  final int? statusCode;
  final String? message;
  final bool? verified;

  VerifyOtpDto({
    this.statusCode,
    this.message,
    this.verified,
  });

  factory VerifyOtpDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpDtoFromJson(json);
}

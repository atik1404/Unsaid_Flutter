import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_params.g.dart';

@JsonSerializable(createFactory: false)
final class VerifyOtpParams {
  @JsonKey(name: 'phone')
  final String phoneNumber;
  @JsonKey(name: 'code')
  final String otp;

  const VerifyOtpParams({
    required this.phoneNumber,
    required this.otp,
  });

  Map<String, dynamic> toJson() => _$VerifyOtpParamsToJson(this);
}

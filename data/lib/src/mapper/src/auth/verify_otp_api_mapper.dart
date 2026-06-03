import 'package:data/src/dto/src/auth/verify_otp_dto.dart';

extension VerifyOtpApiMapper on VerifyOtpDto {
  String toEntity() => message ?? '';
}

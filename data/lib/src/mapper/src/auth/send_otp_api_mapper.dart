import 'package:data/src/dto/src/auth/send_otp_dto.dart';
import 'package:entity/entity.dart';

extension SendOtpApiMapper on SendOtpDto {
  SendOtpEntity toEntity() => SendOtpEntity(
    message: message ?? '',
    accountId: accountId ?? '',
    messageId: messageId ?? '',
  );
}

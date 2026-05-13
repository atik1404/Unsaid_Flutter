import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_verification_state.freezed.dart';

@freezed
abstract class OtpVerificationState with _$OtpVerificationState {
  const factory OtpVerificationState({
    @Default('') String otp,
    @Default(60) int timerSeconds,
    @Default(false) bool canResend,
    @Default(false) bool isVerifying,
    @Default(false) bool isSuccess,
    String? errorMessage,
  }) = _OtpVerificationState;
}

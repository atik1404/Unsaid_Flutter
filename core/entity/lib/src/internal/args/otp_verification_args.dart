final class OtpVerificationArgs {
  const OtpVerificationArgs({
    required this.verificationId,
    required this.phoneNumber,
    required this.otpPurpose,
  });

  final String verificationId;
  final String phoneNumber;
  final String otpPurpose;
}

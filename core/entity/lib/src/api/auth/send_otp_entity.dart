final class SendOtpEntity {
  final String message;
  final String accountId;
  final String messageId;

  SendOtpEntity({
    required this.message,
    required this.accountId,
    required this.messageId,
  });
}

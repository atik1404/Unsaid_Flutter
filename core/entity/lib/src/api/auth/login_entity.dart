final class LoginEntity {
  final String accessToken;
  final String refreshToken;
  final String expireDate;

  LoginEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expireDate,
  });
}

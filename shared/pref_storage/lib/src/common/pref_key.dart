final class PrefKey {
  const PrefKey._();

  static const String accessToken = 'auth.accessToken';
  static const String refreshToken = 'auth.refreshToken';
  static const String loginStatus = 'auth.loginStatus';
  static const String isFirstLaunch = 'auth.isFirstLaunch';

  static const String appLanguage = 'app.language';
  static const String appTheme = 'app.theme';

  static const String fullName = 'user.fullName';
  static const String anonymousName = 'user.anonymousName';
  static const String phoneNumber = 'user.phoneNumber';
  static const String email = 'user.email';
  static const String profilePicture = 'user.profilePicture';
  static const String userId = 'user.userId';
  static const String dateOfBirth = 'user.dateOfBirth';

  static const List<String> securedKey = [accessToken, refreshToken];
}

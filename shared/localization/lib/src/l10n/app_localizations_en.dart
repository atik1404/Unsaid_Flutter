// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get message_no_internet =>
      'Seems like you\'re offline, please check your connection and try again.';

  @override
  String get message_connection_timeout =>
      'Connection timeout, please try again later.';

  @override
  String get message_unknown_error => 'Unknown error, please try again later.';

  @override
  String get message_something_went_wrong =>
      'Something went wrong, please try again later.';

  @override
  String get onboarding_title_1 => 'Share What You Feel';

  @override
  String get onboarding_subtitle_1 => 'Love, anger, confessions—safely';

  @override
  String get onboarding_description_1 =>
      'Post anonymously. Speak your truth. Connect with others without barriers.';

  @override
  String get onboarding_title_2 => 'Speak Freely. Stay Protected.';

  @override
  String get onboarding_subtitle_2 => 'Your voice, your privacy';

  @override
  String get onboarding_description_2 =>
      'Share anything—your identity stays hidden. Your secrets are safe. Express yourself without limits.';

  @override
  String get onboarding_title_3 => 'Everything You Want to Say';

  @override
  String get onboarding_subtitle_3 => 'From whispers to warnings';

  @override
  String get onboarding_description_3 =>
      'Vent, confess, complain—securely and anonymously. Your platform for unfiltered expression.';

  @override
  String get onboarding_get_started => 'Get Started';

  @override
  String get action_retry => 'Try Again';

  @override
  String get login_title => 'Let\'s Get You Signed In';

  @override
  String get login_subtitle =>
      'Sign in to connect through honest, anonymous conversations.';

  @override
  String get login_label_phone => 'Phone number';

  @override
  String get login_hint_phone => 'Enter your phone number';

  @override
  String get login_label_password => 'Password';

  @override
  String get login_hint_password => 'Enter your password';

  @override
  String get login_button => 'Sign In';

  @override
  String get login_forgot_password => 'Forgot Password';

  @override
  String get login_create_account_prompt => 'Don\'t have an account?';

  @override
  String get login_sign_up => 'Sign Up';

  @override
  String get login_social_sign_in => 'Or sign in with';

  @override
  String get login_google => 'Google';

  @override
  String get login_facebook => 'Facebook';

  @override
  String get signup_title => 'Create an Account';

  @override
  String get signup_subtitle =>
      'Join us to connect through honest, anonymous conversations.';

  @override
  String get signup_label_name => 'Full Name';

  @override
  String get signup_hint_name => 'Enter your full name';

  @override
  String get signup_label_phone => 'Phone number';

  @override
  String get signup_hint_phone => 'Enter your phone number';

  @override
  String get signup_label_email => 'Email (Optional)';

  @override
  String get signup_hint_email => 'Enter your email address';

  @override
  String get signup_label_password => 'Password';

  @override
  String get signup_hint_password => 'Create a password';

  @override
  String get signup_button => 'Sign Up';

  @override
  String get signup_already_have_account => 'Already have an account?';

  @override
  String get signup_sign_in => 'Sign In';
}

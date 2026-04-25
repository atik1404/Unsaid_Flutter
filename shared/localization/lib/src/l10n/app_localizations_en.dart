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
  String get onboarding_title_1 => 'The Simple Way to';

  @override
  String get onboarding_subtitle_1 => 'find the best!';

  @override
  String get onboarding_description_1 =>
      'Your perfect movie night starts here. Explore, stream, and love every scene!';

  @override
  String get onboarding_title_2 => 'The Best Design';

  @override
  String get onboarding_subtitle_2 => 'Strategy';

  @override
  String get onboarding_description_2 =>
      'From Oscar winners to hidden gems—every film awaits your spotlight.';

  @override
  String get onboarding_get_started => 'Get Started';
}

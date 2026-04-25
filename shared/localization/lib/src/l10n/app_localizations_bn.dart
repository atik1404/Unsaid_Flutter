// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get message_no_internet =>
      'মনে হচ্ছে আপনি অফলাইনে আছেন, অনুগ্রহ করে আপনার সংযোগ পরীক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get message_connection_timeout =>
      'সংযোগের সময়সীমা শেষ, অনুগ্রহ করে পরে আবার চেষ্টা করুন।';

  @override
  String get message_unknown_error =>
      'অজানা ত্রুটি, অনুগ্রহ করে পরে আবার চেষ্টা করুন।';

  @override
  String get message_something_went_wrong =>
      'কিছু একটা সমস্যা হয়েছে, অনুগ্রহ করে পরে আবার চেষ্টা করুন।';

  @override
  String get onboarding_title_1 => 'সবচেয়ে সহজ উপায়';

  @override
  String get onboarding_subtitle_1 => 'সেরাটি খুঁজে পান!';

  @override
  String get onboarding_description_1 =>
      'আপনার নিখুঁত মুভি নাইট এখানে শুরু হয়। অন্বেষণ করুন, স্ট্রিম করুন এবং প্রতিটি দৃশ্য উপভোগ করুন!';

  @override
  String get onboarding_title_2 => 'সেরা ডিজাইন';

  @override
  String get onboarding_subtitle_2 => 'কৌশল';

  @override
  String get onboarding_description_2 =>
      'অস্কারজয়ী থেকে লুকানো রত্ন—প্রতিটি চলচ্চিত্র আপনার দৃষ্টির অপেক্ষায়।';

  @override
  String get onboarding_get_started => 'শুরু করুন';
}

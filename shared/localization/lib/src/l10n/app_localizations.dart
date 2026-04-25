import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// Error message shown when the user has no active internet connection
  ///
  /// In en, this message translates to:
  /// **'Seems like you\'re offline, please check your connection and try again.'**
  String get message_no_internet;

  /// No description provided for @message_connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout, please try again later.'**
  String get message_connection_timeout;

  /// No description provided for @message_unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Unknown error, please try again later.'**
  String get message_unknown_error;

  /// No description provided for @message_something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again later.'**
  String get message_something_went_wrong;

  /// Title for the first onboarding page
  ///
  /// In en, this message translates to:
  /// **'Share What You Feel'**
  String get onboarding_title_1;

  /// Subtitle for the first onboarding page
  ///
  /// In en, this message translates to:
  /// **'Love, anger, confessions—safely'**
  String get onboarding_subtitle_1;

  /// Description for the first onboarding page
  ///
  /// In en, this message translates to:
  /// **'Post anonymously. Speak your truth. Connect with others without barriers.'**
  String get onboarding_description_1;

  /// Title for the second onboarding page
  ///
  /// In en, this message translates to:
  /// **'Speak Freely. Stay Protected.'**
  String get onboarding_title_2;

  /// Subtitle for the second onboarding page
  ///
  /// In en, this message translates to:
  /// **'Your voice, your privacy'**
  String get onboarding_subtitle_2;

  /// Description for the second onboarding page
  ///
  /// In en, this message translates to:
  /// **'Share anything—your identity stays hidden. Your secrets are safe. Express yourself without limits.'**
  String get onboarding_description_2;

  /// Title for the third onboarding page
  ///
  /// In en, this message translates to:
  /// **'Everything You Want to Say'**
  String get onboarding_title_3;

  /// Subtitle for the third onboarding page
  ///
  /// In en, this message translates to:
  /// **'From whispers to warnings'**
  String get onboarding_subtitle_3;

  /// Description for the third onboarding page
  ///
  /// In en, this message translates to:
  /// **'Vent, confess, complain—securely and anonymously. Your platform for unfiltered expression.'**
  String get onboarding_description_3;

  /// Button label on the last onboarding page
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding_get_started;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

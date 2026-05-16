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

  /// Label for retry button on error screens
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get action_retry;

  /// Login screen main heading
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get You Signed In'**
  String get login_title;

  /// Login screen subtitle below heading
  ///
  /// In en, this message translates to:
  /// **'Sign in to connect through honest, anonymous conversations. Shared moments, safe space.'**
  String get login_subtitle;

  /// Label above the phone number input field
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get login_label_phone;

  /// Hint text inside the phone number input field
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get login_hint_phone;

  /// Label above the password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get login_label_password;

  /// Hint text inside the password input field
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get login_hint_password;

  /// Sign in submit button label
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login_button;

  /// Secondary action label for forgotten password on the sign in screen
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get login_forgot_password;

  /// Prompt shown before the sign up action on the sign in screen
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get login_create_account_prompt;

  /// Call to action for creating a new account from the sign in screen
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get login_sign_up;

  /// Label above social sign in provider buttons
  ///
  /// In en, this message translates to:
  /// **'Or sign in with'**
  String get login_social_sign_in;

  /// Google sign in provider button label
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get login_google;

  /// Facebook sign in provider button label
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get login_facebook;

  /// Signup screen main heading
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get signup_title;

  /// Signup screen subtitle below heading
  ///
  /// In en, this message translates to:
  /// **'Join us to connect through honest, anonymous conversations. Shared moments, safe space.'**
  String get signup_subtitle;

  /// Label above the full name input field
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get signup_label_name;

  /// Hint text inside the full name input field
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get signup_hint_name;

  /// Label above the phone number input field
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get signup_label_phone;

  /// Hint text inside the phone number input field
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get signup_hint_phone;

  /// Label above the email input field
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get signup_label_email;

  /// Hint text inside the email input field
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get signup_hint_email;

  /// Label above the password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signup_label_password;

  /// Hint text inside the password input field
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get signup_hint_password;

  /// Sign up submit button label
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup_button;

  /// Prompt shown before the sign in action on the sign up screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signup_already_have_account;

  /// Call to action for navigating to sign in from the sign up screen
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signup_sign_in;

  /// Title for the Home screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_title;

  /// Message shown when the end of the post list is reached
  ///
  /// In en, this message translates to:
  /// **'No more posts to load.'**
  String get home_no_more_posts;

  /// Title for the Settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setting_title;

  /// Menu item label to navigate to the Profile screen
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get setting_menu_profile;

  /// Menu item label to navigate to the Change Password screen
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get setting_menu_change_password;

  /// Menu item label to navigate to the Change Language screen
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get setting_menu_change_language;

  /// Menu item label for logging out
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get setting_menu_logout;

  /// Title for the logout confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get setting_logout_confirm_title;

  /// Confirmation message shown in the logout dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get setting_logout_confirm_message;

  /// Affirmative action label in the logout dialog
  ///
  /// In en, this message translates to:
  /// **'Yes, Logout'**
  String get setting_logout_confirm_yes;

  /// Dismissive action label in the logout dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get setting_logout_confirm_no;

  /// Title for the Profile screen
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// Label for the user's full name field on the Profile screen
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profile_label_name;

  /// Label for the user's email field on the Profile screen
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profile_label_email;

  /// Label for the user's phone number field on the Profile screen
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get profile_label_phone;

  /// Label for the user's bio field on the Profile screen
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get profile_label_bio;

  /// Section heading for the user's own posts on the Profile screen
  ///
  /// In en, this message translates to:
  /// **'My Posts'**
  String get profile_section_posts;

  /// Empty state message when the user has no posts
  ///
  /// In en, this message translates to:
  /// **'No posts yet.'**
  String get profile_no_posts;

  /// Title for the Change Password screen
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password_title;

  /// Label above the old password input field
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get change_password_label_old;

  /// Hint text inside the old password input field
  ///
  /// In en, this message translates to:
  /// **'Enter your old password'**
  String get change_password_hint_old;

  /// Label above the new password input field
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get change_password_label_new;

  /// Hint text inside the new password input field
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get change_password_hint_new;

  /// Label above the confirm password input field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get change_password_label_confirm;

  /// Hint text inside the confirm password input field
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get change_password_hint_confirm;

  /// Submit button label on the Change Password screen
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get change_password_button;

  /// Success message shown after a password change
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully.'**
  String get change_password_success;

  /// Validation error when new and confirm passwords differ
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get change_password_error_mismatch;

  /// Title for the Post Details screen
  ///
  /// In en, this message translates to:
  /// **'Post Details'**
  String get post_details_title;

  /// Label before the author name on the Post Details screen
  ///
  /// In en, this message translates to:
  /// **'Posted by'**
  String get post_details_posted_by;

  /// Label before the publication date on the Post Details screen
  ///
  /// In en, this message translates to:
  /// **'Posted on'**
  String get post_details_posted_on;

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Foundry Flutter'**
  String get app_title;

  /// Fallback message on the router error screen when route details are unavailable
  ///
  /// In en, this message translates to:
  /// **'Unknown screen'**
  String get nav_unknown_screen;

  /// Back button label on the router error screen
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get nav_back;

  /// Primary brand wordmark shown on splash
  ///
  /// In en, this message translates to:
  /// **'Unsaid'**
  String get splash_brand_name;

  /// First tagline on splash screen
  ///
  /// In en, this message translates to:
  /// **'Things you couldn\'t say anywhere else.'**
  String get splash_tagline_primary;

  /// Second tagline on splash screen
  ///
  /// In en, this message translates to:
  /// **'Shed your identity, not your voice'**
  String get splash_tagline_secondary;

  /// Empty state text when home feed has no posts
  ///
  /// In en, this message translates to:
  /// **'No posts available.'**
  String get home_no_posts_available;

  /// Error shown when posts cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Failed to load posts.'**
  String get home_error_load_posts;

  /// Mock title template for generated home posts
  ///
  /// In en, this message translates to:
  /// **'Post Title {page}-{index}'**
  String home_mock_post_title(int page, int index);

  /// Mock description template for generated home posts
  ///
  /// In en, this message translates to:
  /// **'This is the description for post {page}-{index}. It contains some interesting content about the topic discussed.'**
  String home_mock_post_description(int page, int index);

  /// Mock tag template for generated home posts
  ///
  /// In en, this message translates to:
  /// **'Tag {tagNumber}'**
  String home_mock_post_tag(int tagNumber);

  /// Mock title template for generated profile posts
  ///
  /// In en, this message translates to:
  /// **'My Post {index}'**
  String profile_mock_post_title(int index);

  /// Mock description template for generated profile posts
  ///
  /// In en, this message translates to:
  /// **'This is a description for my post {index}. It shares thoughts and ideas about everyday topics.'**
  String profile_mock_post_description(int index);

  /// Mock tag text for profile posts
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get profile_mock_tag_personal;

  /// Mock profile user name
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get profile_mock_user_name;

  /// Mock profile bio
  ///
  /// In en, this message translates to:
  /// **'Flutter developer | Open-source enthusiast'**
  String get profile_mock_user_bio;

  /// Validation error on signup when required inputs are missing
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields.'**
  String get signup_error_required_fields;

  /// Fallback author name on post details
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get post_details_author_anonymous;

  /// Forgot password screen main heading
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get forgot_password_title;

  /// Forgot password screen subtitle below heading
  ///
  /// In en, this message translates to:
  /// **'No worries! Enter your registered phone number and we\'ll send a one-time code to get you back in.'**
  String get forgot_password_subtitle;

  /// Label above the phone number input field on forgot password screen
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get forgot_password_label_phone;

  /// Hint text inside the phone number input field on forgot password screen
  ///
  /// In en, this message translates to:
  /// **'Enter your registered phone number'**
  String get forgot_password_hint_phone;

  /// Submit button label on forgot password screen
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get forgot_password_button;

  /// Link to navigate back to login from forgot password screen
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get forgot_password_back_to_login;

  /// Validation error when phone number is empty on forgot password screen
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number.'**
  String get forgot_password_error_empty_phone;

  /// Success message after OTP is sent from forgot password screen
  ///
  /// In en, this message translates to:
  /// **'OTP sent! Check your phone for the verification code.'**
  String get forgot_password_success;

  /// OTP verification screen main heading
  ///
  /// In en, this message translates to:
  /// **'Verify Your Number'**
  String get otp_title;

  /// OTP verification screen subtitle with phone number placeholder
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {phone}. Enter it below to continue.'**
  String otp_subtitle(String phone);

  /// Submit button label on OTP verification screen
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otp_button;

  /// Prompt shown before the resend OTP action
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get otp_resend_prompt;

  /// Button to resend OTP when timer expires
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get otp_resend_button;

  /// Countdown timer label shown while resend is disabled
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String otp_resend_timer(int seconds);

  /// Validation error when OTP is incomplete on OTP verification screen
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete 6-digit code.'**
  String get otp_error_incomplete;

  /// Error shown when OTP does not match
  ///
  /// In en, this message translates to:
  /// **'Invalid code. Please check and try again.'**
  String get otp_error_invalid;

  /// Success message after OTP is verified
  ///
  /// In en, this message translates to:
  /// **'Phone number verified successfully.'**
  String get otp_success;

  /// Title for the Notifications screen
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notification_title;

  /// Action button to mark all notifications as read
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notification_action_mark_all_read;

  /// Empty state title on the Notifications screen
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notification_empty_title;

  /// Empty state message on the Notifications screen
  ///
  /// In en, this message translates to:
  /// **'You have no notifications at the moment.'**
  String get notification_empty_message;

  /// Filter pill label to show all notifications
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notification_filter_all;

  /// Filter pill label to show only unread notifications
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notification_filter_unread;

  /// Filter pill label showing unread notification count
  ///
  /// In en, this message translates to:
  /// **'Unread ({count})'**
  String notification_filter_unread_count(int count);

  /// Title for the Create Post screen
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get create_post_title;

  /// Action button label to submit a new post
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get create_post_action_post;

  /// Section heading above the mood selector on the Create Post screen
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get create_post_mood_label;

  /// Hint text inside the post content input field
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get create_post_hint;

  /// Footer note on the Create Post screen about post visibility
  ///
  /// In en, this message translates to:
  /// **'Your post will be visible to everyone. Be mindful of what you share.'**
  String get create_post_visibility_note;

  /// Subtitle shown below the anonymous username on the Create Post screen
  ///
  /// In en, this message translates to:
  /// **'Post anything you want to share with the world!'**
  String get create_post_anonymous_subtitle;

  /// Section heading for identity-related settings
  ///
  /// In en, this message translates to:
  /// **'IDENTITY'**
  String get setting_section_identity;

  /// Section heading for notification settings
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATION'**
  String get setting_section_notification;

  /// Section heading for privacy settings
  ///
  /// In en, this message translates to:
  /// **'PRIVACY'**
  String get setting_section_privacy;

  /// Section heading for destructive account actions
  ///
  /// In en, this message translates to:
  /// **'DANGER ZONE'**
  String get setting_section_danger_zone;

  /// Menu item label to regenerate the user's anonymous alias
  ///
  /// In en, this message translates to:
  /// **'Regenerate alias'**
  String get setting_menu_regenerate_alias;

  /// Menu item label to change the user's avatar
  ///
  /// In en, this message translates to:
  /// **'Change avatar'**
  String get setting_menu_change_avatar;

  /// Subtitle describing available avatar options
  ///
  /// In en, this message translates to:
  /// **'Ghost, skull, alien, robot'**
  String get setting_menu_change_avatar_subtitle;

  /// Menu item label for the dark mode toggle
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get setting_menu_dark_mode;

  /// Subtitle for the dark mode toggle
  ///
  /// In en, this message translates to:
  /// **'Follow system theme'**
  String get setting_menu_dark_mode_subtitle;

  /// Menu item label to toggle anonymous direct messages
  ///
  /// In en, this message translates to:
  /// **'Allow anonymous DMs'**
  String get setting_menu_allow_anonymous_dms;

  /// Subtitle for the allow anonymous DMs toggle
  ///
  /// In en, this message translates to:
  /// **'Strangers can message you.'**
  String get setting_menu_allow_anonymous_dms_subtitle;

  /// Menu item label for the ghost mode toggle
  ///
  /// In en, this message translates to:
  /// **'Ghost mode'**
  String get setting_menu_ghost_mode;

  /// Subtitle for the ghost mode toggle
  ///
  /// In en, this message translates to:
  /// **'Hide your online status.'**
  String get setting_menu_ghost_mode_subtitle;

  /// Menu item label for the push notifications toggle
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get setting_menu_push_notifications;

  /// Menu item label for the sound toggle
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get setting_menu_sound;

  /// Menu item label to delete all of the user's posts
  ///
  /// In en, this message translates to:
  /// **'Wipe all my posts'**
  String get setting_menu_wipe_posts;

  /// Subtitle for the wipe all posts action
  ///
  /// In en, this message translates to:
  /// **'Permanently delete all your posts.'**
  String get setting_menu_wipe_posts_subtitle;

  /// Menu item label to delete the user's account
  ///
  /// In en, this message translates to:
  /// **'Delete ghost account'**
  String get setting_menu_delete_account;

  /// Subtitle for the delete account action
  ///
  /// In en, this message translates to:
  /// **'Permanently delete ghost account.'**
  String get setting_menu_delete_account_subtitle;

  /// Menu item label to sign out
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get setting_menu_sign_out;

  /// Subtitle for the sign out action
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account.'**
  String get setting_menu_sign_out_subtitle;

  /// Menu item label for the language selector
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get setting_menu_language;

  /// Subtitle for the language selector menu item
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get setting_menu_language_subtitle;

  /// Action label to regenerate the user's avatar on the Profile screen
  ///
  /// In en, this message translates to:
  /// **'Regenerate avatar'**
  String get profile_action_regenerate_avatar;

  /// Label for the post count stat on the Profile screen
  ///
  /// In en, this message translates to:
  /// **'POST'**
  String get profile_stat_post;

  /// Label for the reaction count stat on the Profile screen
  ///
  /// In en, this message translates to:
  /// **'REACTION'**
  String get profile_stat_reaction;

  /// Label for the days active stat on the Profile screen
  ///
  /// In en, this message translates to:
  /// **'DAYS'**
  String get profile_stat_days;

  /// Section heading for the user's own posts on the Profile screen
  ///
  /// In en, this message translates to:
  /// **'YOUR CONFESSIONS'**
  String get profile_section_confessions;

  /// Label showing the number of replies on the Post Details screen
  ///
  /// In en, this message translates to:
  /// **'— {count} REPLIES —'**
  String post_details_replies_count(int count);

  /// Hint text inside the comment input box on the Post Details screen
  ///
  /// In en, this message translates to:
  /// **'Write a comment anonymously...'**
  String get post_details_comment_hint;
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

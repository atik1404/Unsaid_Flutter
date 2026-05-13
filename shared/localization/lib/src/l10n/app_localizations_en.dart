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
      'Sign in to connect through honest, anonymous conversations. Shared moments, safe space.';

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
      'Join us to connect through honest, anonymous conversations. Shared moments, safe space.';

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

  @override
  String get home_title => 'Home';

  @override
  String get home_no_more_posts => 'No more posts to load.';

  @override
  String get setting_title => 'Settings';

  @override
  String get setting_menu_profile => 'Profile';

  @override
  String get setting_menu_change_password => 'Change Password';

  @override
  String get setting_menu_change_language => 'Change Language';

  @override
  String get setting_menu_logout => 'Logout';

  @override
  String get setting_logout_confirm_title => 'Logout';

  @override
  String get setting_logout_confirm_message =>
      'Are you sure you want to logout?';

  @override
  String get setting_logout_confirm_yes => 'Yes, Logout';

  @override
  String get setting_logout_confirm_no => 'Cancel';

  @override
  String get profile_title => 'Profile';

  @override
  String get profile_label_name => 'Full Name';

  @override
  String get profile_label_email => 'Email';

  @override
  String get profile_label_phone => 'Phone Number';

  @override
  String get profile_label_bio => 'Bio';

  @override
  String get profile_section_posts => 'My Posts';

  @override
  String get profile_no_posts => 'No posts yet.';

  @override
  String get change_password_title => 'Change Password';

  @override
  String get change_password_label_old => 'Old Password';

  @override
  String get change_password_hint_old => 'Enter your old password';

  @override
  String get change_password_label_new => 'New Password';

  @override
  String get change_password_hint_new => 'Enter your new password';

  @override
  String get change_password_label_confirm => 'Confirm Password';

  @override
  String get change_password_hint_confirm => 'Re-enter your new password';

  @override
  String get change_password_button => 'Update Password';

  @override
  String get change_password_success => 'Password updated successfully.';

  @override
  String get change_password_error_mismatch => 'Passwords do not match.';

  @override
  String get post_details_title => 'Post Details';

  @override
  String get post_details_posted_by => 'Posted by';

  @override
  String get post_details_posted_on => 'Posted on';

  @override
  String get app_title => 'Foundry Flutter';

  @override
  String get nav_unknown_screen => 'Unknown screen';

  @override
  String get nav_back => 'Back';

  @override
  String get splash_brand_name => 'Unsaid';

  @override
  String get splash_tagline_primary =>
      'Things you couldn\'t say anywhere else.';

  @override
  String get splash_tagline_secondary => 'Shed your identity, not your voice';

  @override
  String get home_no_posts_available => 'No posts available.';

  @override
  String get home_error_load_posts => 'Failed to load posts.';

  @override
  String home_mock_post_title(int page, int index) {
    return 'Post Title $page-$index';
  }

  @override
  String home_mock_post_description(int page, int index) {
    return 'This is the description for post $page-$index. It contains some interesting content about the topic discussed.';
  }

  @override
  String home_mock_post_tag(int tagNumber) {
    return 'Tag $tagNumber';
  }

  @override
  String profile_mock_post_title(int index) {
    return 'My Post $index';
  }

  @override
  String profile_mock_post_description(int index) {
    return 'This is a description for my post $index. It shares thoughts and ideas about everyday topics.';
  }

  @override
  String get profile_mock_tag_personal => 'Personal';

  @override
  String get profile_mock_user_name => 'John Doe';

  @override
  String get profile_mock_user_bio =>
      'Flutter developer | Open-source enthusiast';

  @override
  String get signup_error_required_fields =>
      'Please fill in all required fields.';

  @override
  String get post_details_author_anonymous => 'Anonymous';

  @override
  String get forgot_password_title => 'Reset Your Password';

  @override
  String get forgot_password_subtitle =>
      'No worries! Enter your registered phone number and we\'ll send a one-time code to get you back in.';

  @override
  String get forgot_password_label_phone => 'Phone Number';

  @override
  String get forgot_password_hint_phone => 'Enter your registered phone number';

  @override
  String get forgot_password_button => 'Send OTP';

  @override
  String get forgot_password_back_to_login => 'Back to Sign In';

  @override
  String get forgot_password_error_empty_phone =>
      'Please enter your phone number.';

  @override
  String get forgot_password_success =>
      'OTP sent! Check your phone for the verification code.';

  @override
  String get otp_title => 'Verify Your Number';

  @override
  String otp_subtitle(String phone) {
    return 'We sent a 6-digit code to $phone. Enter it below to continue.';
  }

  @override
  String get otp_button => 'Verify';

  @override
  String get otp_resend_prompt => 'Didn\'t receive the code?';

  @override
  String get otp_resend_button => 'Resend OTP';

  @override
  String otp_resend_timer(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get otp_error_incomplete => 'Please enter the complete 6-digit code.';

  @override
  String get otp_error_invalid => 'Invalid code. Please check and try again.';

  @override
  String get otp_success => 'Phone number verified successfully.';
}

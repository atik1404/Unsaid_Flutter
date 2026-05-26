import 'package:change_password/change_password.dart';
import 'package:flutter/material.dart';
import 'package:forgot_password/forgot_password.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:login/login.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:onboarding/onboarding.dart';
import 'package:otp_verification/otp_verification.dart';
import 'package:signup/signup.dart';
import 'package:splash/splash.dart';
import 'package:home/home.dart';
import 'package:reset_password/reset_password.dart';
import 'package:post_details/post_details.dart';
import 'package:setting/setting.dart';
import 'package:create_post/create_post.dart';
import 'package:notification/notification.dart';
import 'package:profile/profile.dart';

Future<void> registerNavigationModule(GetIt locator) async {
  final routers = [
    ...SplashScreenRouter().routes(),
    ...LoginScreenRouter().routes(),
    ...OnboardingScreenRouter().routes(),
    ...SignupScreenRouter().routes(),
    ...ForgotPasswordScreenRouter().routes(),
    ...ResetPasswordScreenRouter().routes(),
    ...OtpVerificationScreenRouter().routes(),
    ...HomeScreenRouter().routes(
      children: [
        ...PostDetailsScreenRouter().routes(),
        ...SettingScreenRouter().routes(),
        ...ChangePasswordScreenRouter().routes(),
        ...CreatePostScreenRouter().routes(),
        ...ProfileScreenRouter().routes(),
        ...NotificationScreenRouter().routes(),
      ],
    ),
  ];

  locator.registerSingleton<GoRouter>(
    GoRouter(
      navigatorKey: rootNavKey,
      initialLocation: AppRouteName.splash,
      observers: [routeObserver],
      routes: routers,
      errorBuilder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.error?.message ?? context.l10n.nav_unknown_screen),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(context.l10n.nav_back),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

/// Convenience getter so [apps] can access the router after DI is initialised.
GoRouter get router => GetIt.instance<GoRouter>();

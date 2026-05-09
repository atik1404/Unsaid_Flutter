import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:login/login.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:onboarding/onboarding.dart';
import 'package:signup/signup.dart';
import 'package:splash/splash.dart';
import 'package:home/home.dart';
import 'package:post_details/post_details.dart';
import 'package:setting/setting.dart';

Future<void> registerNavigationModule(GetIt locator) async {
  final routers = [
    ...SplashScreenRouter().routes(),
    ...LoginScreenRouter().routes(),
    ...OnboardingScreenRouter().routes(),
    ...SignupScreenRouter().routes(),
    ...HomeScreenRouter().routes(
      children: [
        ...PostDetailsScreenRouter().routes(),
        ...SettingScreenRouter().routes(),
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

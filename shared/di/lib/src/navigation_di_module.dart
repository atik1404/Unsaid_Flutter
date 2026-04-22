import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:splash/splash.dart';

Future<void> registerNavigationModule(GetIt locator) async {
  locator.registerSingleton<GoRouter>(
    GoRouter(
      navigatorKey: rootNavKey,
      initialLocation: AppRouteName.splash,
      observers: [routeObserver],
      routes: [
        // ── Auth routes ──
        ...SplashScreenRouter().routes(
          children: [
            // Nested routes under splash go here (e.g. login)
          ],
        ),
      ],
      errorBuilder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.error?.message ?? 'Unknown screen'),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Back'),
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

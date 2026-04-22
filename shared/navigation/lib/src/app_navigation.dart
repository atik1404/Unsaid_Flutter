import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:splash/splash.dart';

final GoRouter router = goRouter();
final routeObserver = RouteObserver<ModalRoute<void>>();
final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();

GoRouter goRouter() {
  return GoRouter(
    initialLocation: AppRouteName.splash,
    routes: [
      // ── Top-level routes ──
      ...SplashScreenRouter().routes(),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.error?.message ?? "Unknown screen"),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text("Back"),
              ),
            ],
          ),
        ),
      );
    },
  );
}

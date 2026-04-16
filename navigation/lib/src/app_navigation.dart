
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';

final GoRouter router = goRouter();
final routeObserver = RouteObserver<ModalRoute<void>>();
final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();

GoRouter goRouter() {
  return GoRouter(
    navigatorKey: rootNavKey,
    observers: [routeObserver],
    routes: [
      // ── Top-level routes ──
      ...SplashRouter().routes(),
      ...OnboardingRouter().routes(),
      ...LoginRouter().routes(),
      ...OtpVerificationRouter().routes(),
      ...RegistrationRouter().routes(),
      ...WebViewRouter().routes(),

      // ── Authenticated routes (nested under home) ──
      ...HomeRouter().routes(
        children: [
          ...LocationSearchRouter().routes(),
          
        ],
      ),
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

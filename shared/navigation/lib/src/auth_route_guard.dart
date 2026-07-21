import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/src/app_route_name.dart';
import 'package:navigation/src/auth_state_notifier.dart';

/// Route names that require an authenticated user.
/// Everything not listed here is public.
const Set<String> privateRouteNames = {
  AppRouteName.createPostScreen,
  AppRouteName.changePasswordScreen,
  AppRouteName.notificationScreen,
  AppRouteName.profileScreen,
  AppRouteName.editProfileScreen,
  AppRouteName.settingScreen,
};

/// Query parameter carrying the location to restore after a successful login.
const String redirectQueryParam = 'redirect';

/// Top-level GoRouter redirect implementing the public/private screen policy.
///
/// - Unauthenticated user navigates to a private screen → sent to login,
///   with the attempted location preserved in a `redirect` query parameter.
/// - Authenticated user lands on login (including right after a successful
///   login flips [authStateNotifier]) → forwarded to the pending destination,
///   or home when there is none.
String? authGuardRedirect(BuildContext context, GoRouterState state) {
  if (context.mounted) {
    //TODO: consider using a provider instead of a global variable
  }
  final isLoggedIn = authStateNotifier.isLoggedIn;
  final routeName = state.topRoute?.name;

  if (!isLoggedIn && privateRouteNames.contains(routeName)) {
    return Uri(
      path: AppRouteName.loginPath,
      queryParameters: {redirectQueryParam: state.uri.toString()},
    ).toString();
  }

  if (isLoggedIn && routeName == AppRouteName.loginScreen) {
    return state.uri.queryParameters[redirectQueryParam] ??
        AppRouteName.homePath;
  }

  return null;
}

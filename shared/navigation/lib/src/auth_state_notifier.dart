import 'package:flutter/foundation.dart';

/// In-memory authentication state used by the router's auth guard.
///
/// Seeded once at startup (in the navigation DI module) from the persisted
/// login status, then updated on login/logout. GoRouter listens to it via
/// [refreshListenable], so every change re-evaluates the route guard:
/// logging in resumes the pending private destination, logging out kicks
/// the user off private screens automatically.
class AuthStateNotifier extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void setLoggedIn({required bool isLoggedIn}) {
    if (_isLoggedIn == isLoggedIn) return;
    _isLoggedIn = isLoggedIn;
    notifyListeners();
  }
}

/// Global auth state. Pass to GoRouter's [refreshListenable] in the DI module.
final AuthStateNotifier authStateNotifier = AuthStateNotifier();

/// ---------------------------------------------------------------------------
/// Analytics event model (vendor-agnostic).
///
/// These are plain, immutable value objects describing "something meaningful a
/// user did". They know nothing about Microsoft Clarity (or any other backend)
/// — that translation happens in the analytics implementation package. Keeping
/// the model here, in pure-Dart `common`, lets every feature emit events while
/// depending only on an abstraction (Dependency Inversion Principle).
///
/// ## Adding a new event
/// Prefer one of the ready-made subclasses below ([ScreenViewEvent],
/// [ButtonClickEvent], [BusinessEvent], [FeatureUsageEvent], [NavigationEvent]).
/// If none fit, create a new subclass of [AnalyticsEvent]. You never have to
/// modify [AnalyticsTracker] or its implementations to add an event — that is
/// the Open/Closed Principle in action.
/// ---------------------------------------------------------------------------
library;

/// Base type for every analytics event in the app.
///
/// An event is just a [name] (the identifier reported to the analytics backend)
/// plus an optional bag of [parameters] giving it context. Subclasses exist to
/// make call sites self-documenting and to keep naming consistent.
abstract class AnalyticsEvent {
  const AnalyticsEvent();

  /// The event identifier sent to the analytics backend. Keep it
  /// `snake_case`, short and stable — dashboards group on this string.
  String get name;

  /// Optional structured context for the event. Keep values primitive
  /// (String / num / bool) so every backend can serialise them.
  Map<String, Object?> get parameters => const <String, Object?>{};

  @override
  String toString() => 'AnalyticsEvent($name, $parameters)';
}

/// A user viewed a screen. Emitted automatically by the navigation observer for
/// every route, so features rarely need to send this by hand.
final class ScreenViewEvent extends AnalyticsEvent {
  const ScreenViewEvent({required this.screenName, this.extra = const {}});

  final String screenName;
  final Map<String, Object?> extra;

  @override
  String get name => AnalyticsEventName.screenView;

  @override
  Map<String, Object?> get parameters => {'screen': screenName, ...extra};
}

/// A navigation transition between two screens — captures the user's journey /
/// flow. Also emitted automatically by the navigation observer.
final class NavigationEvent extends AnalyticsEvent {
  const NavigationEvent({required this.from, required this.to, this.action = 'push'});

  final String? from;
  final String to;

  /// `push`, `pop`, or `replace`.
  final String action;

  @override
  String get name => AnalyticsEventName.navigation;

  @override
  Map<String, Object?> get parameters => {'from': from, 'to': to, 'action': action};
}

/// A user tapped a button / actionable control.
final class ButtonClickEvent extends AnalyticsEvent {
  const ButtonClickEvent({required this.buttonId, this.screen, this.extra = const {}});

  /// Stable identifier for the control, e.g. `login_submit`.
  final String buttonId;

  /// Screen the button lives on, for disambiguation.
  final String? screen;

  final Map<String, Object?> extra;

  @override
  String get name => AnalyticsEventName.buttonClick;

  @override
  Map<String, Object?> get parameters => {
    'button': buttonId,
    if (screen != null) 'screen': screen,
    ...extra,
  };
}

/// An important business/domain event (login succeeded, post created, …).
/// This is the workhorse for "important business events" in the spec.
final class BusinessEvent extends AnalyticsEvent {
  const BusinessEvent(this.name, {this.parameters = const {}});

  @override
  final String name;

  @override
  final Map<String, Object?> parameters;
}

/// A feature was used / engaged with (search opened, filter applied, …).
final class FeatureUsageEvent extends AnalyticsEvent {
  const FeatureUsageEvent({required this.feature, this.action, this.extra = const {}});

  final String feature;
  final String? action;
  final Map<String, Object?> extra;

  @override
  String get name => AnalyticsEventName.featureUsage;

  @override
  Map<String, Object?> get parameters => {
    'feature': feature,
    if (action != null) 'action': action,
    ...extra,
  };
}

/// Canonical, reusable event-name constants. Centralising the "kind" names
/// keeps Clarity dashboards consistent and avoids typos across the codebase.
abstract final class AnalyticsEventName {
  const AnalyticsEventName._();

  static const String screenView = 'screen_view';
  static const String navigation = 'navigation';
  static const String buttonClick = 'button_click';
  static const String featureUsage = 'feature_usage';

  // ── Auth journey ──────────────────────────────────────────────────────────
  static const String loginAttempt = 'login_attempt';
  static const String loginSuccess = 'login_success';
  static const String loginFailure = 'login_failure';
  static const String logout = 'logout';
  static const String signupAttempt = 'signup_attempt';
  static const String signupSuccess = 'signup_success';
  static const String signupFailure = 'signup_failure';
  static const String otpSend = 'otp_send';
  static const String otpVerify = 'otp_verify';
  static const String otpResend = 'otp_resend';
  static const String forgotPasswordRequest = 'forgot_password_request';
  static const String resetPassword = 'reset_password';
  static const String changePassword = 'change_password';
  static const String onboardingComplete = 'onboarding_complete';

  // ── Posts ─────────────────────────────────────────────────────────────────
  static const String feedViewed = 'feed_viewed';
  static const String feedRefreshed = 'feed_refreshed';
  static const String postOpened = 'post_opened';
  static const String postCreateAttempt = 'post_create_attempt';
  static const String postCreateSuccess = 'post_create_success';
  static const String postCreateFailure = 'post_create_failure';
  static const String postReacted = 'post_reacted';
  static const String postCommented = 'post_commented';

  // ── User / account ──────────────────────────────────────────────────────────
  static const String profileViewed = 'profile_viewed';
  static const String profileUpdated = 'profile_updated';
  static const String accountDeleted = 'account_deleted';
  static const String settingToggled = 'setting_toggled';
  static const String notificationOpened = 'notification_opened';
}

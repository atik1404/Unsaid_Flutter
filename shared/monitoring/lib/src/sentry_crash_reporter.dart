import 'package:common/common.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// ---------------------------------------------------------------------------
/// Sentry-backed implementation of the vendor-agnostic [CrashReporter].
///
/// This is the ONLY place in the app that talks to the Sentry SDK. Everything
/// else (repositories, the bloc observer, global handlers) depends on the
/// [CrashReporter] interface from `common`, so Sentry can be swapped or removed
/// without touching feature code (Dependency Inversion Principle).
///
/// Scope model: this reporter uses Sentry's *global* scope for user, tags and
/// breadcrumbs (so they attach to every subsequent event) and a *local* scope
/// per capture for the one-off tags/hint of that specific error.
/// ---------------------------------------------------------------------------
final class SentryCrashReporter implements CrashReporter {
  const SentryCrashReporter();

  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    String? hint,
    Map<String, String>? tags,
    bool fatal = false,
  }) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.level = fatal ? SentryLevel.fatal : SentryLevel.error;
        tags?.forEach(scope.setTag);
        if (hint != null) scope.setContexts('hint', {'value': hint});
      },
    );
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    bool fatal = false,
  }) {
    // Non-fatal errors from a known call site (e.g. a repository/network call).
    // The [context] becomes a searchable tag so issues group by origin.
    return captureException(
      error,
      stackTrace: stackTrace,
      fatal: fatal,
      tags: context == null ? null : {'context': context},
    );
  }

  @override
  Future<void> captureMessage(String message, {Map<String, String>? tags}) async {
    await Sentry.captureMessage(
      message,
      withScope: (scope) => tags?.forEach(scope.setTag),
    );
  }

  @override
  void addBreadcrumb(AppBreadcrumb breadcrumb) {
    // Fire-and-forget; breadcrumbs are buffered by the SDK and attached to the
    // next captured event, giving each crash its "story".
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: breadcrumb.message,
        category: breadcrumb.category,
        level: _mapLevel(breadcrumb.level),
        data: breadcrumb.data.isEmpty ? null : Map<String, Object?>.from(breadcrumb.data),
      ),
    );
  }

  @override
  Future<void> setUser(TelemetryUser? user) async {
    await Sentry.configureScope((scope) async {
      await scope.setUser(
        user == null
            ? null
            : SentryUser(id: user.id, username: user.username, email: user.email),
      );
    });
  }

  @override
  Future<void> setTag(String key, String value) async {
    await Sentry.configureScope((scope) => scope.setTag(key, value));
  }

  /// Translate the vendor-neutral breadcrumb level to Sentry's enum.
  SentryLevel _mapLevel(BreadcrumbLevel level) => switch (level) {
    BreadcrumbLevel.debug => SentryLevel.debug,
    BreadcrumbLevel.info => SentryLevel.info,
    BreadcrumbLevel.warning => SentryLevel.warning,
    BreadcrumbLevel.error => SentryLevel.error,
    BreadcrumbLevel.fatal => SentryLevel.fatal,
  };
}

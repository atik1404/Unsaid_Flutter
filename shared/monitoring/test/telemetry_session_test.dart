import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';

/// Covers [TelemetrySession], which owns the user identity shared by Sentry and
/// Clarity. It lives here rather than in `common` because that package is pure
/// Dart with no test harness, and the crash-reporting half of the session is
/// what the Sentry integration added.
///
/// The behaviour under test is silent when broken — a wrong call order still
/// compiles and still runs, it just attributes reports to the wrong user or to
/// nobody — so it is asserted explicitly.
void main() {
  late _FakeCrashReporter crashReporter;
  late _FakeAnalyticsTracker analytics;
  late TelemetrySession session;

  setUp(() {
    crashReporter = _FakeCrashReporter();
    analytics = _FakeAnalyticsTracker();
    session = TelemetrySession(
      analytics: analytics,
      crashReporter: crashReporter,
    );
  });

  group('start', () {
    test('sets the user on both pipelines', () async {
      await session.start(userId: 'user-42');

      expect(crashReporter.user?.id, 'user-42');
      expect(analytics.userId, 'user-42');
    });

    test('sends only the opaque id — no name, email or phone', () async {
      await session.start(userId: 'user-42');

      expect(crashReporter.user?.username, isNull);
      expect(crashReporter.user?.email, isNull);
    });

    test('ignores a blank id rather than tagging an empty user', () async {
      await session.start(userId: '   ');

      expect(crashReporter.calls, isEmpty);
      expect(analytics.userId, isNull);
    });
  });

  group('end', () {
    test('clears the crash-reporter user', () async {
      await session.start(userId: 'user-42');
      await session.end(reason: 'user_initiated');

      expect(crashReporter.user, isNull);
      expect(crashReporter.calls.last, 'setUser(null)');
    });

    test('resets the analytics session', () async {
      await session.end(reason: 'user_initiated');

      expect(analytics.didReset, isTrue);
    });

    test('records the logout with its reason', () async {
      await session.end(reason: 'session_expired');

      final event = analytics.events.single;
      expect(event.name, AnalyticsEventName.logout);
      expect(event.parameters['reason'], 'session_expired');
    });

    test('logs the logout BEFORE resetting, so it is attributed to the '
        'outgoing session', () async {
      await session.end(reason: 'user_initiated');

      expect(analytics.calls, ['logEvent', 'reset']);
    });
  });

  group('noop', () {
    test('is inert and safe to call', () async {
      const noop = TelemetrySession.noop();

      // Must not throw — used by the data layer before telemetry is registered.
      await noop.start(userId: 'user-42');
      await noop.end(reason: 'session_expired');
    });
  });
}

final class _FakeCrashReporter implements CrashReporter {
  TelemetryUser? user;
  final List<String> calls = [];

  @override
  Future<void> setUser(TelemetryUser? value) async {
    user = value;
    calls.add(value == null ? 'setUser(null)' : 'setUser(${value.id})');
  }

  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    String? hint,
    Map<String, String>? tags,
    bool fatal = false,
  }) async {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    bool fatal = false,
  }) async {}

  @override
  Future<void> captureMessage(String message, {Map<String, String>? tags}) async {}

  @override
  void addBreadcrumb(AppBreadcrumb breadcrumb) {}

  @override
  Future<void> setTag(String key, String value) async {}
}

final class _FakeAnalyticsTracker implements AnalyticsTracker {
  String? userId;
  bool didReset = false;
  final List<AnalyticsEvent> events = [];
  final List<String> calls = [];

  @override
  void logEvent(AnalyticsEvent event) {
    events.add(event);
    calls.add('logEvent');
  }

  @override
  Future<void> setUserId(String? value) async {
    userId = value;
    calls.add('setUserId');
  }

  @override
  Future<void> setCustomTag(String key, String value) async {}

  @override
  Future<void> reset() async {
    didReset = true;
    calls.add('reset');
  }
}

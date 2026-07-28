import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monitoring/monitoring.dart';

/// Covers [CompositeCrashReporter], which is what lets Sentry and Crashlytics
/// run side by side. The important guarantee is failure isolation: this class
/// runs *inside* crash handlers, so an exception escaping it would break the
/// reporting of the very crash it is handling.
void main() {
  late _RecordingReporter first;
  late _RecordingReporter second;
  late CompositeCrashReporter composite;

  setUp(() {
    first = _RecordingReporter();
    second = _RecordingReporter();
    composite = CompositeCrashReporter([first, second]);
  });

  test('forwards captureException to every backend', () async {
    final error = StateError('boom');
    await composite.captureException(error, fatal: true);

    for (final reporter in [first, second]) {
      expect(reporter.calls, ['captureException']);
      expect(reporter.lastError, same(error));
      expect(reporter.lastFatal, isTrue);
    }
  });

  test('forwards user context to every backend', () async {
    await composite.setUser(const TelemetryUser(id: 'user-42'));

    expect(first.user?.id, 'user-42');
    expect(second.user?.id, 'user-42');
  });

  test('forwards a null user (logout) to every backend', () async {
    await composite.setUser(const TelemetryUser(id: 'user-42'));
    await composite.setUser(null);

    expect(first.user, isNull);
    expect(second.user, isNull);
  });

  test('forwards breadcrumbs to every backend', () {
    composite.addBreadcrumb(const AppBreadcrumb(message: 'tapped login'));

    expect(first.breadcrumbs.single.message, 'tapped login');
    expect(second.breadcrumbs.single.message, 'tapped login');
  });

  group('failure isolation', () {
    test('a throwing backend does not stop the others', () async {
      final composite = CompositeCrashReporter([_ThrowingReporter(), second]);

      await composite.captureException(StateError('boom'));

      expect(second.calls, ['captureException']);
    });

    test('a throwing backend does not propagate out of the composite', () async {
      final composite = CompositeCrashReporter([_ThrowingReporter()]);

      // Must not throw — this runs inside the global crash handlers.
      await composite.captureException(StateError('boom'));
      await composite.setUser(null);
      await composite.setTag('flavor', 'prod');
      composite.addBreadcrumb(const AppBreadcrumb(message: 'x'));
    });
  });
}

final class _RecordingReporter implements CrashReporter {
  final List<String> calls = [];
  final List<AppBreadcrumb> breadcrumbs = [];
  Object? lastError;
  bool? lastFatal;
  TelemetryUser? user;

  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    String? hint,
    Map<String, String>? tags,
    bool fatal = false,
  }) async {
    calls.add('captureException');
    lastError = error;
    lastFatal = fatal;
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    bool fatal = false,
  }) async {
    calls.add('recordError');
    lastError = error;
    lastFatal = fatal;
  }

  @override
  Future<void> captureMessage(String message, {Map<String, String>? tags}) async {
    calls.add('captureMessage');
  }

  @override
  void addBreadcrumb(AppBreadcrumb breadcrumb) => breadcrumbs.add(breadcrumb);

  @override
  Future<void> setUser(TelemetryUser? value) async => user = value;

  @override
  Future<void> setTag(String key, String value) async => calls.add('setTag');
}

final class _ThrowingReporter implements CrashReporter {
  @override
  Future<void> captureException(
    Object error, {
    StackTrace? stackTrace,
    String? hint,
    Map<String, String>? tags,
    bool fatal = false,
  }) async => throw StateError('backend down');

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    bool fatal = false,
  }) async => throw StateError('backend down');

  @override
  Future<void> captureMessage(String message, {Map<String, String>? tags}) async =>
      throw StateError('backend down');

  @override
  void addBreadcrumb(AppBreadcrumb breadcrumb) => throw StateError('backend down');

  @override
  Future<void> setUser(TelemetryUser? user) async => throw StateError('backend down');

  @override
  Future<void> setTag(String key, String value) async =>
      throw StateError('backend down');
}

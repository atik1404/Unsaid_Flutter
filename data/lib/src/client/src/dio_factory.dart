import 'package:app_env/environment.dart';
import 'package:common/common.dart';
import 'package:data/src/interceptor/interceptor.dart';
import 'package:dio/dio.dart';
import 'package:pref_storage/pref_storage.dart';

/// Builds the app's Dio clients.
///
/// ## Variant-aware diagnostics
///
/// Every diagnostic interceptor is gated on [DebugFeatures], which is derived
/// from the *build type* (debug vs release) — never from the environment. This
/// is what makes `devRelease` behave like a real release build: it talks to the
/// development backend but logs nothing.
///
/// The previous implementation gated on `AppConfig.I.environment.isDev ||
/// kDebugMode`. Because `isDev` is true for `devRelease`, that shipped full
/// request/response bodies and `Authorization` headers in a signed, shrunk
/// release build. Adding a QA or staging environment would have silently
/// extended the same leak.
///
/// Because [DebugFeatures] is built from compile-time constants, the `if`
/// blocks below are tree-shaken out of release binaries entirely — the
/// interceptors are not merely inert, they are absent.
final class DioFactory {
  const DioFactory._();

  static const _defaultTimeout = Duration(seconds: 30);
  static const _uploadTimeout = Duration(seconds: 60);

  static const _jsonHeaders = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Adds the diagnostic interceptors permitted for the current build variant.
  ///
  /// Centralized so a new client cannot forget the gating, and so the policy
  /// changes in exactly one place.
  static void _addDiagnostics(Dio dio) {
    final features = AppConfig.I.debugFeatures;

    if (features.apiLogging) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    if (features.accessTokenLogging) {
      dio.interceptors.add(TokenLoggerInterceptor());
    }
  }

  /// API client — uses [AppConfig.baseUrl] for all JSON endpoints.
  ///
  /// [tokenRefreshDio] must be a clean Dio created via [createTokenRefreshClient]
  /// so the refresh call itself never triggers another 401 cycle.
  static Dio create({
    required AppPrefStorage prefStorage,
    required Dio tokenRefreshDio,
    TelemetrySession telemetrySession = const TelemetrySession.noop(),
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.I.baseUrl,
        connectTimeout: _defaultTimeout,
        receiveTimeout: _defaultTimeout,
        sendTimeout: _defaultTimeout,
        headers: _jsonHeaders,
      ),
    );

    _addDiagnostics(dio);
    dio.interceptors.add(
      TokenRefreshInterceptor(
        tokenRefreshDio: tokenRefreshDio,
        prefStorage: prefStorage,
        telemetrySession: telemetrySession,
      ),
    );
    dio.interceptors.add(RetryInterceptor(dio: dio));
    return dio;
  }

  /// Image-upload client — uses [AppConfig.imageUrl] (different host/port).
  static Dio createImageClient(
    AppPrefStorage prefStorage, {
    TelemetrySession telemetrySession = const TelemetrySession.noop(),
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.I.imageUrl,
        connectTimeout: _uploadTimeout,
        receiveTimeout: _uploadTimeout,
        sendTimeout: _uploadTimeout,
        headers: const {'Accept': 'application/json'},
      ),
    );

    _addDiagnostics(dio);
    dio.interceptors.add(
      TokenRefreshInterceptor(
        tokenRefreshDio: dio,
        prefStorage: prefStorage,
        telemetrySession: telemetrySession,
      ),
    );
    dio.interceptors.add(RetryInterceptor(dio: dio));
    return dio;
  }

  /// Bare client used solely to refresh an expired token.
  ///
  /// Intentionally carries no [TokenRefreshInterceptor]: a 401 on the refresh
  /// endpoint itself must surface, not recurse.
  static Dio createTokenRefreshClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.I.baseUrl,
        connectTimeout: _defaultTimeout,
        receiveTimeout: _defaultTimeout,
        sendTimeout: _defaultTimeout,
        headers: _jsonHeaders,
      ),
    );

    _addDiagnostics(dio);
    return dio;
  }
}

// Imported directly rather than through the `environment.dart` barrel: that
// barrel re-exports this file, so importing it here would be self-referential.
import 'package:app_env/src/config/app_environment.dart';
import 'package:app_env/src/config/build_variant.dart';
import 'package:app_env/src/config/debug_features.dart';
import 'package:app_env/src/envied/dev_env.dart';
import 'package:app_env/src/envied/env_fields.dart';
import 'package:app_env/src/envied/prod_env.dart';
import 'package:flutter/foundation.dart';

/// The single source of truth for all environment- and variant-dependent
/// configuration.
///
/// This is the "dedicated configuration layer" for the project. It — not
/// Android's `BuildConfig` — is authoritative, because every consumer of these
/// values (Dio clients, interceptors, feature gates) is Dart code. Android's
/// generated `BuildConfig` fields are JVM constants that Dart cannot read
/// without a platform channel, so mirroring URLs there would create a second,
/// silently divergent source of truth. `BuildConfig` therefore carries only the
/// flavor name, for native/crash-reporting use.
///
/// ## Two axes
///
/// ```
///   AppEnvironment (Gradle flavor)     → baseUrl, imageUrl, secrets, Firebase
///   BuildVariant   (Gradle build type) → debugFeatures (logging, tooling)
/// ```
///
/// Values on the first axis come from envied-generated classes backed by the
/// `.env_development` / `.env_production` files. Values on the second are
/// derived from compile-time constants; see [DebugFeatures].
///
/// ## Adding an environment (qa, staging, uat, …)
///
/// 1. Add the value to [AppEnvironment].
/// 2. Add `.env_qa` plus a `QaEnv` envied class implementing [EnvFields].
/// 3. Add the branch to [_envFieldsFor] below.
/// 4. Add `apps/lib/main_qa.dart` and the Gradle flavor + `google-services.json`.
///
/// No existing branch changes, and nothing about logging needs touching —
/// a QA *release* is silent for the same reason a prod release is.
@immutable
class AppConfig {
  /// Which backend/identity this build targets. Comes from the Gradle flavor
  /// via the Dart entry point (`main_dev.dart` / `main_prod.dart`).
  final AppEnvironment environment;

  /// How this binary was compiled (debug/profile/release).
  final BuildVariant buildVariant;

  /// Diagnostic capabilities permitted for [buildVariant]. Always consult this
  /// rather than testing `kDebugMode` at the call site.
  final DebugFeatures debugFeatures;

  final String baseUrl;
  final String imageUrl;
  final String apiSecret;
  final String projectId;

  /// Sentry DSN for this environment. Empty ⇒ crash reporting runs as a no-op.
  final String sentryDsn;

  /// Microsoft Clarity project id for this environment. Empty ⇒ Clarity
  /// session recording is skipped and analytics runs as a no-op.
  final String clarityProjectId;

  const AppConfig._({
    required this.environment,
    required this.buildVariant,
    required this.debugFeatures,
    required this.baseUrl,
    required this.imageUrl,
    required this.apiSecret,
    required this.projectId,
    required this.sentryDsn,
    required this.clarityProjectId,
  });

  /// Builds the configuration for [environment], resolving the debug-feature
  /// set from the compile-time [BuildVariant].
  ///
  /// This is the only constructor callers should use: it guarantees the two
  /// axes are combined consistently, so no call site can accidentally pair a
  /// production environment with debug logging.
  factory AppConfig.of(AppEnvironment environment) {
    final env = _envFieldsFor(environment);
    final variant = BuildVariant.current;

    return AppConfig._(
      environment: environment,
      buildVariant: variant,
      debugFeatures: DebugFeatures.forVariant(variant),
      baseUrl: env.appBaseUrl,
      imageUrl: env.appImageUrl,
      apiSecret: env.apiSecret,
      projectId: env.projectId,
      sentryDsn: env.sentryDsn,
      clarityProjectId: env.clarityProjectId,
    );
  }

  /// Maps an environment onto its envied-generated field bundle. The single
  /// place that needs a new branch when an environment is added.
  static EnvFields _envFieldsFor(AppEnvironment environment) {
    return switch (environment) {
      AppEnvironment.dev => DevEnv(),
      AppEnvironment.prod => ProdEnv(),
    };
  }

  // ── Singleton access ──────────────────────────────────────────────────
  //
  // Initialized exactly once from `bootstrap()` before the DI container or any
  // Dio client is constructed.
  static AppConfig? _instance;

  /// The active configuration.
  ///
  /// Throws a [StateError] if read before [init]. This is deliberately loud:
  /// silently returning a default would mean falling back to some other
  /// environment's base URL.
  static AppConfig get I {
    final instance = _instance;
    if (instance == null) {
      throw StateError(
        'AppConfig.I read before AppConfig.init(). Call init() in bootstrap() '
        'before constructing the DI container or any Dio client.',
      );
    }
    return instance;
  }

  static void init(AppConfig config) => _instance = config;

  /// Test-only reset so suites can install a different environment.
  @visibleForTesting
  static void reset() => _instance = null;

  @override
  String toString() =>
      'AppConfig(environment: ${environment.label}, buildVariant: '
      '${buildVariant.name}, baseUrl: $baseUrl, debugFeatures: $debugFeatures)';
}

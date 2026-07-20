import 'package:app_env/src/config/build_variant.dart';
import 'package:flutter/foundation.dart';

/// The single switchboard for every developer-facing / diagnostic capability.
///
/// Nothing in the app should test `kDebugMode` or `environment.isDev` inline to
/// decide whether to log; it should ask this object. That keeps the policy in
/// one reviewable place instead of scattered across call sites, where a single
/// missed condition ships token logging to production.
///
/// ## Policy
///
/// Every flag is driven by the [BuildVariant] (build type), **never** by the
/// [AppEnvironment] (flavor). The resulting matrix is exactly the required one:
///
/// | Variant       | API logs | Token logs | Inspector | Verbose | Debug tools |
/// |---------------|----------|------------|-----------|---------|-------------|
/// | `devDebug`    | ✅       | ✅         | ✅        | ✅      | ✅          |
/// | `devRelease`  | ❌       | ❌         | ❌        | ❌      | ❌          |
/// | `prodDebug`   | ✅       | ✅         | ✅        | ✅      | ✅          |
/// | `prodRelease` | ❌       | ❌         | ❌        | ❌      | ❌          |
///
/// Adding a new environment (qa, staging, …) therefore needs no change here at
/// all — a QA release is silent for the same reason a prod release is.
@immutable
class DebugFeatures {
  /// Log full HTTP request/response bodies (Dio `LogInterceptor`).
  final bool apiLogging;

  /// Log the `Authorization` header / access token.
  ///
  /// Separate from [apiLogging] because it is the most sensitive of the two and
  /// may need to be suppressed even while general API logging is on.
  final bool accessTokenLogging;

  /// Attach network-inspector tooling (on-device request browsers, proxies).
  final bool networkInspector;

  /// Emit verbose diagnostic logs from non-network subsystems.
  final bool verboseLogging;

  /// Show in-app developer affordances: debug banners, environment badges,
  /// feature-flag panels, etc.
  final bool debugTools;

  const DebugFeatures({
    required this.apiLogging,
    required this.accessTokenLogging,
    required this.networkInspector,
    required this.verboseLogging,
    required this.debugTools,
  });

  /// Everything on. Debug builds only.
  const DebugFeatures.enabled()
    : apiLogging = true,
      accessTokenLogging = true,
      networkInspector = true,
      verboseLogging = true,
      debugTools = true;

  /// Everything off — the safe default for anything that is not a debug build.
  const DebugFeatures.disabled()
    : apiLogging = false,
      accessTokenLogging = false,
      networkInspector = false,
      verboseLogging = false,
      debugTools = false;

  /// Resolves the flag set for [variant], defaulting to [DebugFeatures.disabled]
  /// for every non-debug variant (fail-closed).
  factory DebugFeatures.forVariant(BuildVariant variant) =>
      variant.allowsDebugTooling
      ? const DebugFeatures.enabled()
      : const DebugFeatures.disabled();

  /// True when any diagnostic capability is active. Useful for a single
  /// top-level guard (e.g. showing a "DEBUG" badge in the UI).
  bool get anyEnabled =>
      apiLogging ||
      accessTokenLogging ||
      networkInspector ||
      verboseLogging ||
      debugTools;

  /// Returns a copy with individual flags overridden.
  ///
  /// Intended for tests and for narrowly disabling one capability in a debug
  /// build (e.g. muting token logs while screen-sharing). It cannot be used to
  /// *enable* anything in a release build, because release builds start from
  /// [DebugFeatures.disabled] and this app only ever constructs the flag set
  /// through [DebugFeatures.forVariant].
  DebugFeatures copyWith({
    bool? apiLogging,
    bool? accessTokenLogging,
    bool? networkInspector,
    bool? verboseLogging,
    bool? debugTools,
  }) {
    return DebugFeatures(
      apiLogging: apiLogging ?? this.apiLogging,
      accessTokenLogging: accessTokenLogging ?? this.accessTokenLogging,
      networkInspector: networkInspector ?? this.networkInspector,
      verboseLogging: verboseLogging ?? this.verboseLogging,
      debugTools: debugTools ?? this.debugTools,
    );
  }

  @override
  String toString() =>
      'DebugFeatures(apiLogging: $apiLogging, accessTokenLogging: '
      '$accessTokenLogging, networkInspector: $networkInspector, '
      'verboseLogging: $verboseLogging, debugTools: $debugTools)';
}

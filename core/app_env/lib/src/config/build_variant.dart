import 'package:flutter/foundation.dart';

/// How this binary was compiled — the Dart mirror of Android's *build type*.
///
/// This is the second of the two independent axes that define a build variant:
///
/// ```
///   AppEnvironment (flavor)    → which backend / app identity   (dev | prod)
///   BuildVariant   (buildType) → how noisy / how optimized      (debug | release)
/// ```
///
/// Keeping them separate is what makes `devRelease` behave like a release build
/// (silent, shrunk) while still pointing at the development backend. Deriving
/// debug behaviour from the *environment* instead would leak request bodies and
/// access tokens from every dev release build.
///
/// The values map 1:1 onto Gradle's build types, because Flutter sets
/// [kDebugMode] / [kProfileMode] / [kReleaseMode] from the same `--debug`,
/// `--profile`, `--release` flag that selects the Gradle build type.
enum BuildVariant {
  debug,
  profile,
  release;

  /// Resolved at compile time — these constants are canonicalized by the
  /// compiler, so branches on them are tree-shaken out of release binaries.
  static BuildVariant get current {
    if (kDebugMode) return BuildVariant.debug;
    if (kProfileMode) return BuildVariant.profile;
    return BuildVariant.release;
  }

  bool get isDebug => this == BuildVariant.debug;
  bool get isRelease => this == BuildVariant.release;

  /// Whether developer-facing instrumentation may be switched on.
  ///
  /// Only `debug` qualifies. `profile` is deliberately excluded: it is a
  /// performance-measurement build that ships without the debug tooling, and
  /// logging would both distort the measurements and expose real traffic.
  bool get allowsDebugTooling => this == BuildVariant.debug;
}

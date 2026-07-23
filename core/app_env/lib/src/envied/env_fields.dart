abstract class EnvFields {
  String get appBaseUrl;
  String get appImageUrl;
  String get apiSecret;
  String get projectId;

  /// Sentry ingestion endpoint for this environment. May be empty — the crash
  /// reporter then initialises to a no-op, so builds work without it.
  String get sentryDsn;

  /// Microsoft Clarity project id for this environment. May be empty — Clarity
  /// session recording is then skipped and analytics runs as a no-op.
  String get clarityProjectId;
}

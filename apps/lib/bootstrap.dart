import 'package:analytics/analytics.dart';
import 'package:app/app_di.dart';
import 'package:app/app_entry.dart';
import 'package:app/default_firebase_options.dart';
import 'package:app_env/environment.dart';
import 'package:common/common.dart';
import 'package:di/di.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:monitoring/monitoring.dart';
import 'package:pref_storage/pref_storage.dart';

/// Whether crashes are uploaded to Firebase Crashlytics.
///
/// On for every flavor and build type, so a crash is reported wherever it
/// happens and the integration can be verified without a special build. The dev
/// and prod flavors are separate Firebase *apps* (`com.user.unsaid.dev` vs
/// `com.user.unsaid`) inside one project, so their crashes stay separated in
/// the console.
///
/// To stop debug-build noise (deliberate crashes, hot-reload errors) reaching
/// the console, change this to `!kDebugMode`. Crashlytics still needs a real
/// crash + relaunch to upload, so release builds remain the way to test it
/// properly.
const bool _crashlyticsEnabled = true;

Future<void> bootstrap(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  // ═══════════════════════════════════════════
  // 1. Environment Config (envied based)
  //
  // Resolved first because Sentry needs the DSN and DI needs the config.
  // ═══════════════════════════════════════════
  AppConfig.init(AppConfig.of(environment));
  final config = AppConfig.I;

  // ═══════════════════════════════════════════
  // 2. Firebase
  //
  // Initialised before either crash backend because Crashlytics cannot be
  // touched until it completes.
  // ═══════════════════════════════════════════
  final firebaseOptions = DefaultFirebaseOptions.currentPlatform;
  await Firebase.initializeApp(options: firebaseOptions);
  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: true,
  );

  // ═══════════════════════════════════════════
  // 3. Crashlytics — MUST be installed before Sentry.
  //
  // Sentry's error integrations chain onto whatever handlers already exist, so
  // installing Crashlytics first means both backends see every Dart error.
  // Doing it the other way round would overwrite Sentry's handlers instead.
  // See `CrashlyticsInitializer.install`.
  // ═══════════════════════════════════════════
  await CrashlyticsInitializer.install(enabled: _crashlyticsEnabled);

  // ═══════════════════════════════════════════
  // 4. Sentry (stability monitoring) + guarded zone
  //
  // `MonitoringInitializer.run` initialises Sentry (crash/ANR/native only) and
  // runs the ENTIRE remaining bootstrap inside Sentry's guarded zone, so any
  // uncaught async error during startup is also reported. When no DSN is set,
  // it just runs `appRunner` (Sentry disabled, no-op reporter registered in DI).
  // ═══════════════════════════════════════════
  await MonitoringInitializer.run(
    dsn: config.sentryDsn,
    environment: config.environment.name,
    // Sentry's own SDK logging follows the same variant policy as every other
    // diagnostic in the app — never on in a release binary.
    debug: config.debugFeatures.verboseLogging,
    appRunner: () async {
      // ── 5. DI (telemetry → data → domain → navigation) ─────────────────────
      final getIt = GetIt.instance;
      await configureDependencies(
        getIt,
        environment,
        crashlyticsEnabled: _crashlyticsEnabled,
      );
      await registerAppDiModule();

      // ── 6. Route all unhandled bloc errors into the crash reporter ─────────
      Bloc.observer = getIt<AppBlocObserver>();

      // ── 7. Restore user + tag context for this session ─────────────────────
      await _restoreTelemetryContext(getIt, config);

      // ═══════════════════════════════════════════
      // 8. Run App — wrapped for Microsoft Clarity session recording.
      //    ClarityAppWrapper is transparent (returns the child) when the
      //    Clarity project id is empty.
      // ═══════════════════════════════════════════
      runApp(
        ClarityAppWrapper(
          projectId: config.clarityProjectId,
          child: const AppEntry(),
        ),
      );
    },
  );
}

/// Seeds crash-report and analytics context from the persisted session so warm
/// starts are attributed to the right (pseudonymous) user, and every report is
/// tagged with the build's flavor/variant. Device & OS are added natively by
/// Sentry, so we don't duplicate them here.
Future<void> _restoreTelemetryContext(GetIt getIt, AppConfig config) async {
  final crashReporter = getIt<CrashReporter>();
  await crashReporter.setTag('flavor', config.environment.name);
  await crashReporter.setTag('build_variant', config.buildVariant.name);

  // Mirror the build dimensions onto the analytics session so Clarity
  // recordings can be filtered by flavor/variant the same way crash reports
  // are. These are session-scoped (they describe the build, not one event),
  // which is exactly what Clarity's custom tags are for.
  final analytics = getIt<AnalyticsTracker>();
  await analytics.setCustomTag('flavor', config.environment.name);
  await analytics.setCustomTag('build_variant', config.buildVariant.name);

  final prefs = getIt<AppPrefStorage>();
  if (!prefs.getBoolean(PrefKey.loginStatus)) return;

  final userId = prefs.getString(PrefKey.userId);
  if (userId.isEmpty) return;

  // Warm start with a persisted session: re-attach the user to both pipelines
  // so this launch is attributed to the same account as the login that created
  // the session. Runs before `runApp`, so a crash during the first frame is
  // already tied to the right user.
  await getIt<TelemetrySession>().start(userId: userId);
}

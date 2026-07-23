import 'package:analytics/analytics.dart';
import 'package:app/app_di.dart';
import 'package:app/app_entry.dart';
import 'package:app/default_firebase_options.dart';
import 'package:app_env/environment.dart';
import 'package:common/common.dart';
import 'package:di/di.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:monitoring/monitoring.dart';
import 'package:pref_storage/pref_storage.dart';

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
  // 2. Sentry (stability monitoring) + guarded zone
  //
  // `MonitoringInitializer.run` initialises Sentry (crash/ANR/native only) and
  // runs the ENTIRE remaining bootstrap inside Sentry's guarded zone, so any
  // uncaught async error during startup is also reported. When no DSN is set,
  // it just runs `appRunner` (Sentry disabled, no-op reporter registered in DI).
  // ═══════════════════════════════════════════
  await MonitoringInitializer.run(
    dsn: config.sentryDsn,
    environment: config.environment.name,
    appRunner: () async {
      // ── 3. Firebase ────────────────────────────────────────────────────────
      final firebaseOptions = DefaultFirebaseOptions.currentPlatform;
      await Firebase.initializeApp(options: firebaseOptions);
      await FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: true,
      );

      // ── 4. Crashlytics — kept alongside Sentry (per integration decision).
      //     Enabled only in prod. We add NO new Crashlytics capture calls, so a
      //     given error is never reported to both backends by our code.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        environment == AppEnvironment.prod,
      );

      // ── 5. DI (telemetry → data → domain → navigation) ─────────────────────
      final getIt = GetIt.instance;
      await configureDependencies(getIt, environment);
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

  final prefs = getIt<AppPrefStorage>();
  if (!prefs.getBoolean(PrefKey.loginStatus)) return;

  final userId = prefs.getString(PrefKey.userId);
  if (userId.isEmpty) return;

  await crashReporter.setUser(TelemetryUser(id: userId));
  await getIt<AnalyticsTracker>().setUserId(userId);
}

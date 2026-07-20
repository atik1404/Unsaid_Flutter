import 'package:app/app_di.dart';
import 'package:app/app_entry.dart';
import 'package:app/default_firebase_options.dart';
import 'package:app_env/environment.dart';
import 'package:di/di.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> bootstrap(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  // ═══════════════════════════════════════════
  // 1. Environment Config (envied based)
  //
  // `AppConfig.of` resolves both axes at once: the environment (flavor) picks
  // the base URLs and secrets, while the compile-time build variant picks the
  // debug-feature set. Must run before DI, since the Dio clients read it.
  // ═══════════════════════════════════════════
  AppConfig.init(AppConfig.of(environment));

  // ═══════════════════════════════════════════
  // 2. Firebase
  // ═══════════════════════════════════════════
  final firebaseOptions = DefaultFirebaseOptions.currentPlatform;
  await Firebase.initializeApp(options: firebaseOptions);

  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: true,
  );

  // ═══════════════════════════════════════════
  // 3. Crashlytics — disable in dev mode
  // ═══════════════════════════════════════════
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    environment == AppEnvironment.prod,
  );

  // ═══════════════════════════════════════════
  // 4. DI
  // ═══════════════════════════════════════════
  final getIt = GetIt.instance;
  await configureDependencies(getIt, environment);
  await registerAppDiModule();

  // ═══════════════════════════════════════════
  // 5. Storage lifecycle handling - because keychain persists after app uninstall
  // ═══════════════════════════════════════════

  //await getIt<AppPrefStorage>().onAppStart();

  // ═══════════════════════════════════════════
  // Run App
  // ═══════════════════════════════════════════
  runApp(const AppEntry());
}

import 'package:app/app_di.dart';
import 'package:app/app_entry.dart';
import 'package:app_env/environment.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pref_storage/pref_storage.dart';

Future<void> bootstrap(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  // ═══════════════════════════════════════════
  // 1. Environment Config (envied based)
  // ═══════════════════════════════════════════
  final envConfig = switch (environment) {
    AppEnvironment.dev => AppConfig.dev(DevEnv()),
    AppEnvironment.prod => AppConfig.prod(ProdEnv()),
  };
  AppConfig.init(envConfig);

  // ═══════════════════════════════════════════
  // 2. Firebase
  // ═══════════════════════════════════════════
  // final firebaseOptions = switch (environment) {
  //   AppEnvironment.dev => firebase_dev.DefaultFirebaseOptions.currentPlatform,
  //   AppEnvironment.prod => firebase_prod.DefaultFirebaseOptions.currentPlatform,
  // };
  // await Firebase.initializeApp(options: firebaseOptions);

  // ═══════════════════════════════════════════
  // 3. Crashlytics — disable in dev mode
  // ═══════════════════════════════════════════
  // await FirebaseCrashlytics.instance .setCrashlyticsCollectionEnabled(environment == AppEnvironment.prod);

  // ═══════════════════════════════════════════
  // 4. DI
  // ═══════════════════════════════════════════
  final getIt = GetIt.instance;
  await configureDependencies(getIt, environment);

  // ═══════════════════════════════════════════
  // 5. Storage lifecycle handling - because keychain persists after app uninstall
  // ═══════════════════════════════════════════

  await getIt<StorageRepository>().onAppStart();

  // ═══════════════════════════════════════════
  // Run App
  // ═══════════════════════════════════════════
  runApp(const AppEntry());
}

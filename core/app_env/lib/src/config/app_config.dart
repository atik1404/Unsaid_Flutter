import 'package:app_env/environment.dart';
import 'package:app_env/src/envied/env_fields.dart';

class AppConfig {
  final AppEnvironment environment;
  final String baseUrl;
  final String imageUrl;
  final String apiSecret;
  final String projectId;
  final bool enableLogging;

  const AppConfig._({required this.environment, required this.baseUrl, required this.imageUrl, required this.apiSecret, required this.projectId, required this.enableLogging});

  factory AppConfig.dev(EnvFields env) {
    return AppConfig._(environment: AppEnvironment.dev, baseUrl: env.appBaseUrl, imageUrl: env.appImageUrl, apiSecret: env.apiSecret, projectId: env.projectId, enableLogging: true);
  }

  factory AppConfig.prod(EnvFields env) {
    return AppConfig._(environment: AppEnvironment.prod, baseUrl: env.appBaseUrl, imageUrl: env.appImageUrl, apiSecret: env.apiSecret, projectId: env.projectId, enableLogging: false);
  }

  // ── Singleton access ──
  static late final AppConfig _instance;
  static AppConfig get I => _instance;

  static void init(AppConfig config) {
    _instance = config;
  }
}

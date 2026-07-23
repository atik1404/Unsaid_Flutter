import 'env_fields.dart';
import 'package:envied/envied.dart';

part 'dev_env.g.dart';

@Envied(path: '.env_development', name: 'DevEnv')
final class DevEnv implements EnvFields {
  @override
  @EnviedField(varName: 'API_SECRET')
  final String apiSecret = _DevEnv.apiSecret;

  @override
  @EnviedField(varName: 'API_BASE_URL')
  final String appBaseUrl = _DevEnv.appBaseUrl;

  @override
  @EnviedField(varName: 'IMAGE_BASE_URL')
  final String appImageUrl = _DevEnv.appImageUrl;

  @override
  @EnviedField(varName: 'PROJECT_ID')
  final String projectId = _DevEnv.projectId;

  @override
  @EnviedField(varName: 'SENTRY_DSN', defaultValue: '')
  final String sentryDsn = _DevEnv.sentryDsn;

  @override
  @EnviedField(varName: 'CLARITY_PROJECT_ID', defaultValue: '')
  final String clarityProjectId = _DevEnv.clarityProjectId;
}

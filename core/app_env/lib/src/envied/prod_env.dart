import 'env_fields.dart';
import 'package:envied/envied.dart';

part 'prod_env.g.dart';

@Envied(path: '.env_production', name: 'ProdEnv')
final class ProdEnv implements EnvFields {
  @override
  @EnviedField(varName: 'API_SECRET')
  final String apiSecret = _ProdEnv.apiSecret;

  @override
  @EnviedField(varName: 'API_BASE_URL')
  final String appBaseUrl = _ProdEnv.appBaseUrl;

  @override
  @EnviedField(varName: 'IMAGE_BASE_URL')
  final String appImageUrl = _ProdEnv.appImageUrl;

  @override
  @EnviedField(varName: 'PROJECT_ID')
  final String projectId = _ProdEnv.projectId;

  @override
  @EnviedField(varName: 'SENTRY_DSN', defaultValue: '')
  final String sentryDsn = _ProdEnv.sentryDsn;

  @override
  @EnviedField(varName: 'CLARITY_PROJECT_ID', defaultValue: '')
  final String clarityProjectId = _ProdEnv.clarityProjectId;
}

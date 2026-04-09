import 'package:common/common.dart';
import 'package:domain/src/params/login_params.dart';
import 'package:entity/entity.dart';

abstract class AuthRepository {
  Future<Result<LoginEntity, Failure>> login(LoginParams params);
}

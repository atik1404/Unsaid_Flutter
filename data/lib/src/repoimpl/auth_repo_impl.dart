import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:entity/entity.dart';

final class AuthRepoImpl extends AuthRepository {
  @override
  Future<Result<LoginEntity, Failure>> login(LoginParams params) {
    // TODO: implement login
    throw UnimplementedError();
  }
}

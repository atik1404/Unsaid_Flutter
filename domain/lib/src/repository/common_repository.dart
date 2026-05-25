import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:entity/entity.dart';

abstract class CommonRepository {
  Future<Result<CommonApiEntity, Failure>> checkUserExistence(UserParams params);
}

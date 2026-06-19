import 'package:common/common.dart';

abstract class CommonRepository {
  Future<Result<String, Failure>> fetchExample();
}

import 'package:common/common.dart';
import 'package:data/data.dart';
import 'package:data/src/dto/src/common/common_dto.dart';
import 'package:data/src/mapper/mapper.dart';
import 'package:domain/domain.dart';

final class CommonRepoImpl implements CommonRepository {
  CommonRepoImpl(this._restClient);

  final RestClient _restClient;

  @override
  Future<Result<String, Failure>> fetchExample() async {
    final result = await _restClient.post(
      '/auth/check-user',
      options: AuthOptions.authenticated(),
      parser: (data) => CommonDto.fromJson(data).toEntity(),
    );
    return result as Result<String, Failure>;
  }
}

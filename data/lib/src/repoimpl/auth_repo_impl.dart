import 'package:common/common.dart';
import 'package:data/data.dart';
import 'package:data/src/mapper/auth/login_mapper.dart';
import 'package:data/src/mapper/auth/profile_mapper.dart';
import 'package:data/src/network/api_handler.dart';
import 'package:domain/domain.dart';
import 'package:entity/entity.dart';
import 'package:response/response.dart';

final class AuthRepoImpl extends AuthRepository with ApiHandler {
  final NetworkClient _client;

  AuthRepoImpl(this._client);

  @override
  Future<Result<LoginEntity, Failure>> login(LoginParams params) {
    return execute(() async {
      final response = await _client.post(
        '/login',
        data: params.toJson(),
      );

      return LoginDto.fromJson(response).toEntity();
    });
  }

  @override
  Future<Result<ProfileEntity, Failure>> fetchProfile() {
    return execute(() async {
      final response = await _client.get(
        '/fetchProfile',
      );

      return UserProfileDto.fromJson(response).toEntity();
    });
  }
}

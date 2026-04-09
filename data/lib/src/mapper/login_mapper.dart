import 'package:entity/entity.dart';
import 'package:response/response.dart';

extension LoginMapper on LoginDto {
  LoginEntity toEntity() => LoginEntity(
    accessToken: accessToken ?? "",
    refreshToken: refreshToken ?? "",
  );
}

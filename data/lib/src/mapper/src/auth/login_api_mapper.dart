import 'package:data/src/dto/dto.dart';
import 'package:entity/entity.dart';

extension LoginApiMapper on LoginApiResponse {
  LoginEntity toEntity() => LoginEntity(
    accessToken: authToken ?? '',
    refreshToken: refreshToken ?? '',
    expireDate: expirationDate ?? '',
  );
}

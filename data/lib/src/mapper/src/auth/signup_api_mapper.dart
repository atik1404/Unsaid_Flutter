import 'package:data/src/dto/dto.dart';
import 'package:entity/entity.dart';

extension SignupApiMapper on SignupDto {
  LoginEntity toEntity() => LoginEntity(
    accessToken: authToken ?? '',
    refreshToken: refreshToken ?? '',
    expireDate: expirationDate ?? '',
  );
}

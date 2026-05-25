import 'package:data/src/dto/dto.dart';
import 'package:entity/entity.dart';

extension ProfileApiMapper on ProfileDto {
  ProfileEntity toEntity() => ProfileEntity(
    name: data?.name ?? '',
    email: data?.email ?? '',
  );
}

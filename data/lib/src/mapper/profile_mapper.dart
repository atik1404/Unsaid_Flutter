import 'package:entity/entity.dart';
import 'package:response/response.dart';

extension ProfileMapper on UserProfileDto {
  ProfileEntity toEntity() => ProfileEntity(
    name: name ?? "",
    email: email ?? "",
  );
}

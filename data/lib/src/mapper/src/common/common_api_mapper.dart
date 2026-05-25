import 'package:data/src/dto/src/common/common_dto.dart';
import 'package:entity/entity.dart';

extension CommonApiMapper on CommonDto {
  CommonApiEntity toEntity() => CommonApiEntity(
    message:  '',
    exists: exists ?? false,
    statusCode: statusCode ?? 0,
  );
}

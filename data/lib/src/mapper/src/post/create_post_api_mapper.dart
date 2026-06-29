import 'package:data/src/dto/src/post/create_post_dto.dart';
import 'package:entity/entity.dart';

/// Maps the [CreatePostDto] transport object into the domain [CreatePostEntity],
/// substituting safe defaults for any missing fields.
extension CreatePostApiMapper on CreatePostDto {
  CreatePostEntity toEntity() => CreatePostEntity(
    statusCode: statusCode ?? 0,
    message: message ?? '',
  );
}

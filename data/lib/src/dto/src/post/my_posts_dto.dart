import 'package:data/src/dto/dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_posts_dto.g.dart';

@JsonSerializable(createToJson: false)
class MyPostsDto {
  final List<PostDto>? data;
  final PostMetaDto? meta;

  const MyPostsDto({this.data, this.meta});

  factory MyPostsDto.fromJson(Map<String, dynamic> json) => _$MyPostsDtoFromJson(json);
}
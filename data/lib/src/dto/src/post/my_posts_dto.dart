import 'package:data/src/dto/dto.dart';

class MyPostsDto {
  final List<PostDto>? posts;

  const MyPostsDto({this.posts});

  /// The endpoint returns a top-level array, so this takes a [List] rather than
  /// a map. json_serializable can't target a top-level array, hence the manual
  /// factory instead of `@JsonSerializable`.
  factory MyPostsDto.fromJson(List<dynamic> json) => MyPostsDto(
    posts: json
        .whereType<Map<String, dynamic>>()
        .map(PostDto.fromJson)
        .toList(),
  );
}

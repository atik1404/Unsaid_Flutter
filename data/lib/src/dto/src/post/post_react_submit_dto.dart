import 'package:json_annotation/json_annotation.dart';

part 'post_react_submit_dto.g.dart';

@JsonSerializable(createToJson: false)
class PostReactSubmitDto {
  @JsonKey(name: 'status_code')
  final int? statusCode;
  final String? message;
  final ReactData? data;

  const PostReactSubmitDto({this.statusCode, this.message, this.data});

  factory PostReactSubmitDto.fromJson(Map<String, dynamic> json) =>
      _$PostReactSubmitDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class ReactData {
  @JsonKey(name: 'post_id')
  final String? postId;
  final String? react;
  @JsonKey(name: 'reaction_count')
  final int? reactionCount;

  const ReactData({this.postId, this.react, this.reactionCount});

  factory ReactData.fromJson(Map<String, dynamic> json) =>
      _$ReactDataFromJson(json);
}

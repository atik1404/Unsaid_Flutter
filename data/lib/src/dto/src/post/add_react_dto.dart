import 'package:json_annotation/json_annotation.dart';

part 'add_react_dto.g.dart';

@JsonSerializable(createToJson: false)
class AddReactDto {
  @JsonKey(name: 'status_code')
  final int? statusCode;
  final String? message;
  final AddReactData? data;

  const AddReactDto({this.statusCode, this.message, this.data});

  factory AddReactDto.fromJson(Map<String, dynamic> json) => _$AddReactDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class AddReactData {
  @JsonKey(name: 'post_id')
  final String? postId;
  final String? react;
  @JsonKey(name: 'reaction_count')
  final int? reactionCount;

  const AddReactData({this.postId, this.react, this.reactionCount});

  factory AddReactData.fromJson(Map<String, dynamic> json) => _$AddReactDataFromJson(json);
}

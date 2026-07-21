import 'package:json_annotation/json_annotation.dart';

part 'create_post_dto.g.dart';

/// Raw API response for `POST /posts`.
///
/// The endpoint only acknowledges creation, so the payload is limited to a
/// status code and a human readable message.
@JsonSerializable(createToJson: false)
class CreatePostDto {
  @JsonKey(name: 'status_code')
  final int? statusCode;
  final String? message;

  const CreatePostDto({this.statusCode, this.message});

  factory CreatePostDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePostDtoFromJson(json);
}

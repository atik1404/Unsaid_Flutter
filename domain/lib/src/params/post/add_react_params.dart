import 'package:json_annotation/json_annotation.dart';

part 'add_react_params.g.dart';

@JsonSerializable(
  createFactory: false,
)
final class AddReactParams {
  @JsonKey(name: 'react')
  final String react;
  @JsonKey(name: 'post_id', includeToJson: false)
  final String postId;

  const AddReactParams({required this.react, required this.postId});

  Map<String, dynamic> toJson() => _$AddReactParamsToJson(this);
}

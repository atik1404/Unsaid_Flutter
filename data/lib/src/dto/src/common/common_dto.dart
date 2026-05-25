import 'package:json_annotation/json_annotation.dart';

part 'common_dto.g.dart';

@JsonSerializable(createToJson: false)
class CommonDto {
  final List<String>? message;
  final bool? exists;
  @JsonKey(name: 'status_code')
  final int? statusCode;

  const CommonDto({this.message, this.exists, this.statusCode});

  factory CommonDto.fromJson(Map<String, dynamic> json) => _$CommonDtoFromJson(json);
}

import 'package:json_annotation/json_annotation.dart';

part 'user_params.g.dart';

@JsonSerializable(
  createFactory: false,
)
final class UserParams {
  final String identifier; // email or phone number
  const UserParams({
    required this.identifier,
  });

  Map<String, dynamic> toJson() => _$UserParamsToJson(this);
}

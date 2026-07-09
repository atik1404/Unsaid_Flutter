import 'package:json_annotation/json_annotation.dart';

part 'update_profile_params.g.dart';

/// Request payload for the `PATCH /profile` endpoint.
///
/// Only the editable identity fields are sent, serialized to the snake_case
/// keys the API expects (`full_name`, `email`, `phone_e164`, `bio`). Null
/// fields are omitted so a partial update never overwrites untouched values.
@JsonSerializable(createFactory: false, includeIfNull: false)
final class UpdateProfileParams {
  @JsonKey(name: 'full_name')
  final String fullName;
  final String email;
  @JsonKey(name: 'phone_e164')
  final String phoneE164;
  final String? bio;

  const UpdateProfileParams({
    required this.fullName,
    required this.email,
    required this.phoneE164,
    this.bio,
  });

  Map<String, dynamic> toJson() => _$UpdateProfileParamsToJson(this);
}

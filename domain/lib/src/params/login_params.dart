import 'package:json_annotation/json_annotation.dart';

part 'login_params.g.dart';

@JsonSerializable(
  createFactory: false,
)
final class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$LoginParamsToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'signup_params.g.dart';

@JsonSerializable(
  createFactory: false,
)
final class SignupParams {
  final String fullname; // email or phone number
  final String password;
  final String? email;
  final String phone;

  const SignupParams({
    required this.fullname,
    required this.password,
    required this.phone,
    this.email,
  });

  Map<String, dynamic> toJson() => _$SignupParamsToJson(this);
}

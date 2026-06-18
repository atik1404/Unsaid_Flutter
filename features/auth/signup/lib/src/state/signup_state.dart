import 'package:common/common.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_state.freezed.dart';

@freezed
abstract class SignupState with _$SignupState {
  const factory SignupState({
    @Default(PhoneInputValidator.pure()) PhoneInputValidator phone,
    @Default(PasswordInputValidator.pure()) PasswordInputValidator password,
    @Default(NameInputValidator.pure()) NameInputValidator name,
    @Default(EmailInputValidator.pure()) EmailInputValidator email,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    @Default(false) bool showPassword,
    String? errorMessage,
  }) = _SignupState;
}

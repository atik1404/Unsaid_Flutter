import 'package:common/common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default(PhoneInputValidator.pure()) PhoneInputValidator phone,
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    @Default(false) bool showError,
    String? accountId,
    String? errorMessage,
  }) = _ForgotPasswordState;
}

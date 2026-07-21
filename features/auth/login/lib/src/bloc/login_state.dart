import 'package:common/common.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

/// Represents the complete UI state of the Login screen.
///
/// [phone] and [password] are Formz inputs that carry both the raw value
/// and any validation error.
///
/// [showErrors] starts as `false` so validation messages stay hidden until
/// the user explicitly taps the login button for the first time.
///
/// [status] tracks the async submission lifecycle (initial → inProgress →
/// success | failure).
///
/// [errorMessage] holds a server-side or network error message when
/// [status] is [FormzSubmissionStatus.failure].
@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(PhoneInputValidator.pure()) PhoneInputValidator phone,
    @Default(PasswordInputValidator.pure()) PasswordInputValidator password,

    /// Flip to `true` on the first submit attempt to reveal inline errors.
    @Default(false) bool showErrors,

    /// Flip to `true` to reveal the password text.
    @Default(false) bool showPassword,

    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    String? errorMessage,
  }) = _LoginState;
  const LoginState._();

  /// `true` only when both fields satisfy their respective validators.
  bool get isValid => Formz.validate([phone, password]);

  bool get isLoading => status == FormzSubmissionStatus.inProgress;
}

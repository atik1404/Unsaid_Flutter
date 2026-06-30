import 'package:common/common.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_state.freezed.dart';

/// State for the Change Password screen.
///
/// Each password field is a Formz [PasswordInputValidator] so inline
/// validation can be surfaced per-field. [showError] gates whether those
/// inline errors are visible (only after the first submit attempt), and
/// [status] drives the loading / success / error transitions.
@freezed
abstract class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default(PasswordInputValidator.pure()) PasswordInputValidator oldPassword,
    @Default(PasswordInputValidator.pure()) PasswordInputValidator newPassword,
    @Default(PasswordInputValidator.pure()) PasswordInputValidator confirmPassword,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(false) bool showError,
    String? errorMessage,
    String? successMessage,
  }) = _ChangePasswordState;
}

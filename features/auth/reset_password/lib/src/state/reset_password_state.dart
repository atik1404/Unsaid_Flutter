import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_state.freezed.dart';

/// State for the Reset Password screen.
///
/// Tracks form submission status and any validation/server errors.
/// [isSuccess] is set to `true` after a successful password update
/// so the UI can show a confirmation message.
@freezed
abstract class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorMessage,
  }) = _ResetPasswordState;
}

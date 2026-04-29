import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_state.freezed.dart';

/// State for the Change Password screen.
///
/// Tracks form submission status and any validation/server errors.
/// [isSuccess] is set to `true` after a successful password update
/// so the UI can show a confirmation message.
@freezed
abstract class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorMessage,
  }) = _ChangePasswordState;
}

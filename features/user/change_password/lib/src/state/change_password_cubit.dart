import 'package:change_password/src/state/change_password_state.dart';
import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

/// Manages the state for the Change Password screen.
///
/// Holds the three password fields as Formz inputs, validates them, and
/// delegates the actual update to [ChangePasswordUseCase]. The new and
/// confirm fields must additionally match before the request is sent.
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordCubit({required this._changePasswordUseCase})
    : super(const ChangePasswordState());

  void updateOldPassword(String value) {
    emit(
      state.copyWith(
        oldPassword: PasswordInputValidator.dirty(value),
        errorMessage: null,
      ),
    );
  }

  void updateNewPassword(String value) {
    emit(
      state.copyWith(
        newPassword: PasswordInputValidator.dirty(value),
        errorMessage: null,
      ),
    );
  }

  void updateConfirmPassword(String value) {
    emit(
      state.copyWith(
        confirmPassword: PasswordInputValidator.dirty(value),
        errorMessage: null,
      ),
    );
  }

  /// Validates the form and, if valid, calls the change-password use case.
  Future<void> changePassword() async {
    // Re-dirty every field so the validator runs against the current values,
    // and flip `showError` so inline messages become visible from now on.
    final oldPassword = PasswordInputValidator.dirty(state.oldPassword.value);
    final newPassword = PasswordInputValidator.dirty(state.newPassword.value);
    final confirmPassword = PasswordInputValidator.dirty(
      state.confirmPassword.value,
    );

    emit(
      state.copyWith(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        showError: true,
        errorMessage: null,
      ),
    );

    // Abort early on any field-level error — the UI already shows them inline.
    if (!oldPassword.isValid ||
        !newPassword.isValid ||
        !confirmPassword.isValid) {
      return;
    }

    // New and confirm must match; the mismatch is surfaced inline by the UI.
    if (newPassword.value != confirmPassword.value) return;

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );

    final result = await _changePasswordUseCase(
      ChangePasswordParams(
        oldPassword: oldPassword.value,
        newPassword: newPassword.value,
        confirmPassword: confirmPassword.value,
      ),
    );

    result.when(
      success: (message) => emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          successMessage: message,
          errorMessage: null,
        ),
      ),
      failure: (error) {
        // Resolve the failure into a displayable message (raw string or l10n key).
        final message = switch (error.message) {
          RawStringMessage(:final value) => value,
          LocaleKeyMessage(:final key) => key.name,
        };

        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: message,
          ),
        );
      },
    );
  }

  /// Resets the state so the form can be reused after a successful change.
  void resetState() {
    emit(const ChangePasswordState());
  }
}

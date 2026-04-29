import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:change_password/src/state/change_password_state.dart';

/// Manages the state for the Change Password screen.
///
/// Validates that the new and confirm passwords match, then
/// simulates a network call to update the password.
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(const ChangePasswordState());

  /// Attempts to change the user's password.
  ///
  /// [oldPassword]    – the user's current password.
  /// [newPassword]    – the desired new password.
  /// [confirmPassword] – must match [newPassword] to proceed.
  ///
  /// Emits a loading state, validates inputs, simulates an API call,
  /// and finally emits either a success or error result.
  void changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));

    // Validate that new and confirm passwords match
    if (newPassword != confirmPassword) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'mismatch', // mapped to l10n key by the UI
        ),
      );
      return;
    }

    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(isLoading: false, isSuccess: true));
  }

  /// Resets the state so the form can be reused.
  void resetState() {
    emit(const ChangePasswordState());
  }
}

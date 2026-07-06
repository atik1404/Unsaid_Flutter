import 'package:common/common.dart';
import 'package:delete_account/src/models/delete_account_reason.dart';
import 'package:delete_account/src/state/delete_account_state.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

/// Manages the state for the Delete Account screen.
///
/// Tracks the selected reason, the optional free-text details, and the typed
/// confirmation keyword. Once every precondition passes ([DeleteAccountState.canSubmit])
/// it delegates the destructive request to [DeleteAccountUseCase]. Clearing the
/// local session and navigating away is left to the presentation layer, which
/// reacts to the terminal success state.
class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final DeleteAccountUseCase _deleteAccountUseCase;

  DeleteAccountCubit({required this._deleteAccountUseCase}) : super(const DeleteAccountState());

  /// Records the reason the user picked. Clearing the details when a non-"Other"
  /// reason is chosen keeps stale text from being submitted.
  void selectReason(DeleteAccountReason reason) {
    emit(
      state.copyWith(
        selectedReason: reason,
        otherDetails: reason.requiresDetails ? state.otherDetails : '',
        errorMessage: null,
      ),
    );
  }

  /// Mirrors the free-text "Other" details.
  void updateOtherDetails(String value) {
    emit(state.copyWith(otherDetails: value, errorMessage: null));
  }

  /// Mirrors the confirmation input so the delete button can arm itself.
  void updateConfirmationText(String value) {
    emit(state.copyWith(confirmationText: value, errorMessage: null));
  }

  /// Validates the form and, if valid, calls the delete-account use case.
  ///
  /// Flips [DeleteAccountState.showError] so inline messages become visible, and
  /// guards against duplicate in-flight requests.
  Future<void> deleteAccount() async {
    if (state.status.isInProgress) return;

    // Surface inline validation from now on; abort if anything is still invalid.
    if (!state.canSubmit) {
      emit(state.copyWith(showError: true, errorMessage: null));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress, showError: true, errorMessage: null));

    final reason = state.selectedReason!;
    final details = state.otherDetails.trim();
    final result = await _deleteAccountUseCase(
      DeleteAccountParams(
        reason: reason.apiKey,
        details: reason.requiresDetails && details.isNotEmpty ? details : null,
      ),
    );

    result.when(
      success: (message) => emit(
        state.copyWith(status: FormzSubmissionStatus.success, successMessage: message, errorMessage: null),
      ),
      failure: (error) {
        // Resolve the failure into a displayable message (raw string or l10n key).
        final message = switch (error.message) {
          RawStringMessage(:final value) => value,
          LocaleKeyMessage(:final key) => key.name,
        };

        emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: message));
      },
    );
  }
}

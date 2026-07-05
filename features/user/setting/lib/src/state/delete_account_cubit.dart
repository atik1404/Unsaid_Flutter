import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:setting/src/state/delete_account_state.dart';

/// Manages the state for the delete-account confirmation bottom sheet.
///
/// Tracks the confirmation text the user types and, once it exactly matches
/// [deleteAccountKeyword], delegates the destructive request to
/// [DeleteAccountUseCase]. Clearing local session data and navigating away is
/// left to the presentation layer, which reacts to the success state.
class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final DeleteAccountUseCase _deleteAccountUseCase;

  DeleteAccountCubit({required this._deleteAccountUseCase}) : super(const DeleteAccountState());

  /// Mirrors the confirmation input so the delete button can arm itself.
  void updateConfirmationText(String value) {
    emit(state.copyWith(confirmationText: value, errorMessage: null));
  }

  /// Calls the delete-account use case, but only when the typed text exactly
  /// matches the required keyword. Guards against duplicate in-flight requests.
  Future<void> deleteAccount() async {
    if (!state.isConfirmed || state.status.isInProgress) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress, errorMessage: null));

    final result = await _deleteAccountUseCase();

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

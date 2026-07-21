import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:setting/src/state/delete_all_posts_state.dart';

/// Manages the state for the delete-all-posts confirmation bottom sheet.
///
/// Tracks the confirmation text the user types and, once it exactly matches
/// [deleteAllPostsKeyword], delegates the destructive request to
/// [DeleteAllPostsUseCase]. The presentation layer reacts to the success state.
class DeleteAllPostsCubit extends Cubit<DeleteAllPostsState> {
  final DeleteAllPostsUseCase _deleteAllPostsUseCase;

  DeleteAllPostsCubit({required this._deleteAllPostsUseCase})
    : super(const DeleteAllPostsState());

  /// Mirrors the confirmation input so the delete button can arm itself.
  void updateConfirmationText(String value) {
    emit(state.copyWith(confirmationText: value, errorMessage: null));
  }

  /// Calls the delete-all-posts use case, but only when the typed text exactly
  /// matches the required keyword. Guards against duplicate in-flight requests.
  Future<void> deleteAllPosts() async {
    if (!state.isConfirmed || state.status.isInProgress) return;

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );

    final result = await _deleteAllPostsUseCase();

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
}

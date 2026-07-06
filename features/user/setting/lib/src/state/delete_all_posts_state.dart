import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_all_posts_state.freezed.dart';

/// The exact keyword the user must type (case-sensitive) to arm the
/// destructive delete-all-posts action.
const String deleteAllPostsKeyword = 'DELETE';

/// State for the delete-all-posts confirmation bottom sheet.
///
/// [confirmationText] mirrors the input field; the delete action is only armed
/// once it exactly matches [deleteAllPostsKeyword] (surfaced via [isConfirmed]).
/// [status] drives the loading / success / error transitions.
@freezed
abstract class DeleteAllPostsState with _$DeleteAllPostsState {
  const factory DeleteAllPostsState({
    @Default('') String confirmationText,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    String? errorMessage,
    String? successMessage,
  }) = _DeleteAllPostsState;

  // Private constructor enabling the computed [isConfirmed] getter below.
  const DeleteAllPostsState._();

  /// Whether the typed text exactly matches the required keyword.
  bool get isConfirmed => confirmationText == deleteAllPostsKeyword;
}

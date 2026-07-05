import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_account_state.freezed.dart';

/// The exact keyword the user must type (case-sensitive) to arm the
/// destructive delete action.
const String deleteAccountKeyword = 'DELETE';

/// State for the delete-account confirmation bottom sheet.
///
/// [confirmationText] mirrors the input field; the delete action is only armed
/// once it exactly matches [deleteAccountKeyword] (surfaced via [isConfirmed]).
/// [status] drives the loading / success / error transitions.
@freezed
abstract class DeleteAccountState with _$DeleteAccountState {
  const factory DeleteAccountState({
    @Default('') String confirmationText,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    String? errorMessage,
    String? successMessage,
  }) = _DeleteAccountState;

  // Private constructor enabling the computed [isConfirmed] getter below.
  const DeleteAccountState._();

  /// Whether the typed text exactly matches the required keyword.
  bool get isConfirmed => confirmationText == deleteAccountKeyword;
}

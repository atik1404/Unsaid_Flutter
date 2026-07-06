import 'package:delete_account/src/models/delete_account_reason.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_account_state.freezed.dart';

/// The exact keyword the user must type (case-sensitive) to arm the
/// destructive delete action.
const String deleteAccountKeyword = 'DELETE';

/// State for the Delete Account screen.
///
/// The destructive action is only armed once the user has (1) picked a
/// [selectedReason], (2) supplied [otherDetails] when that reason is "Other",
/// and (3) typed [confirmationText] exactly matching [deleteAccountKeyword].
/// [showError] gates whether inline validation messages are visible (only after
/// the first submit attempt) and [status] drives the loading / success / error
/// transitions.
@freezed
abstract class DeleteAccountState with _$DeleteAccountState {
  const factory DeleteAccountState({
    DeleteAccountReason? selectedReason,
    @Default('') String otherDetails,
    @Default('') String confirmationText,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(false) bool showError,
    String? errorMessage,
    String? successMessage,
  }) = _DeleteAccountState;

  // Private constructor enabling the computed getters below.
  const DeleteAccountState._();

  /// Whether the "Other" free-text details are required but still missing.
  bool get isOtherDetailsMissing =>
      selectedReason?.requiresDetails == true && otherDetails.trim().isEmpty;

  /// Whether a reason is selected and any required details are provided.
  bool get isReasonValid => selectedReason != null && !isOtherDetailsMissing;

  /// Whether the typed confirmation text exactly matches the required keyword.
  bool get isConfirmed => confirmationText == deleteAccountKeyword;

  /// Whether all preconditions for the destructive request are satisfied.
  bool get canSubmit => isReasonValid && isConfirmed;
}

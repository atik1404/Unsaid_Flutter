import 'package:common/common.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_profile_state.freezed.dart';

/// State for the Edit Profile screen.
///
/// Each editable field is a Formz input so inline validation can be surfaced
/// per-field. The `initial*` snapshots capture the values the form was
/// pre-populated with, enabling dirty-tracking so the Save button stays
/// disabled until the user actually changes something. [showError] gates
/// whether inline errors are visible (only after the first submit attempt),
/// and [status] drives the loading / success / error transitions.
@freezed
abstract class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    @Default(NameInputValidator.pure()) NameInputValidator fullName,
    @Default(EmailInputValidator.pure()) EmailInputValidator email,
    @Default(PhoneInputValidator.pure()) PhoneInputValidator phone,
    @Default(BioInputValidator.pure()) BioInputValidator bio,

    // Snapshot of the pre-populated values, used for dirty-tracking.
    @Default('') String initialFullName,
    @Default('') String initialEmail,
    @Default('') String initialPhone,
    @Default('') String initialBio,

    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(false) bool showError,
    String? errorMessage,
    String? successMessage,
  }) = _EditProfileState;

  const EditProfileState._();

  /// True while an update request is in flight.
  bool get isSubmitting => status.isInProgress;

  /// True once any editable field differs from its pre-populated value.
  bool get isDirty =>
      fullName.value != initialFullName ||
      email.value != initialEmail ||
      phone.value != initialPhone ||
      bio.value != initialBio;

  /// Every field passes its validator.
  bool get isFormValid => Formz.validate([fullName, email, phone, bio]);

  /// The form can only be submitted with valid, changed data and no in-flight
  /// request.
  bool get canSubmit => isDirty && isFormValid && !isSubmitting;
}

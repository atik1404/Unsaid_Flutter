import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:edit_profile/src/state/edit_profile_state.dart';
import 'package:entity/entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

/// Manages the state for the Edit Profile screen.
///
/// Seeds each Formz field from the [ProfileEntity] the screen was opened with
/// (so the form is pre-populated and dirty-tracking has a baseline), validates
/// edits, and delegates the update to [UpdateProfileUseCase].
class EditProfileCubit extends Cubit<EditProfileState> {
  final UpdateProfileUseCase _updateProfileUseCase;

  EditProfileCubit({
    required UpdateProfileUseCase updateProfileUseCase,
    required ProfileEntity profile,
  }) : _updateProfileUseCase = updateProfileUseCase,
       super(_seed(profile));

  /// Builds the initial pre-populated state from the current profile. Fields
  /// are seeded `dirty` so they carry real values (and validate) while
  /// [EditProfileState.showError] keeps inline errors hidden until the first
  /// submit attempt.
  static EditProfileState _seed(ProfileEntity profile) {
    final identity = profile.identity;
    final bio = identity.bio ?? '';
    return EditProfileState(
      fullName: NameInputValidator.dirty(identity.fullName),
      email: EmailInputValidator.dirty(identity.email),
      phone: PhoneInputValidator.dirty(identity.phoneE164),
      bio: BioInputValidator.dirty(bio),
      initialFullName: identity.fullName,
      initialEmail: identity.email,
      initialPhone: identity.phoneE164,
      initialBio: bio,
    );
  }

  void updateFullName(String value) {
    emit(
      state.copyWith(
        fullName: NameInputValidator.dirty(value),
        errorMessage: null,
      ),
    );
  }

  void updateEmail(String value) {
    emit(
      state.copyWith(
        email: EmailInputValidator.dirty(value),
        errorMessage: null,
      ),
    );
  }

  void updatePhone(String value) {
    emit(
      state.copyWith(
        phone: PhoneInputValidator.dirty(value),
        errorMessage: null,
      ),
    );
  }

  void updateBio(String value) {
    emit(
      state.copyWith(bio: BioInputValidator.dirty(value), errorMessage: null),
    );
  }

  /// Validates the form and, if valid and changed, calls the update use case.
  Future<void> save() async {
    // Re-dirty every field so the validator runs against the current values,
    // and flip `showError` so inline messages become visible from now on.
    final fullName = NameInputValidator.dirty(state.fullName.value);
    final email = EmailInputValidator.dirty(state.email.value);
    final phone = PhoneInputValidator.dirty(state.phone.value);
    final bio = BioInputValidator.dirty(state.bio.value);

    emit(
      state.copyWith(
        fullName: fullName,
        email: email,
        phone: phone,
        bio: bio,
        showError: true,
        errorMessage: null,
      ),
    );

    // Abort on any field-level error — the UI already shows them inline.
    if (!Formz.validate([fullName, email, phone, bio])) return;

    // Nothing to submit if the user hasn't changed anything.
    if (!state.isDirty) return;

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );

    final result = await _updateProfileUseCase(
      UpdateProfileParams(
        fullName: fullName.value,
        email: email.value,
        phoneE164: phone.value,
        bio: bio.value.isEmpty ? null : bio.value,
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
}

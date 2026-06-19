import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signup/src/state/signup_event.dart';
import 'package:signup/src/state/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final FetchUserExistenceUseCase _fetchUserExistenceUseCase;

  SignupBloc({required FetchUserExistenceUseCase fetchUserExistenceUseCase}) : _fetchUserExistenceUseCase = fetchUserExistenceUseCase, super(const SignupState()) {
    on<NameUpdate>(_onNameUpdate);
    on<EmailUpdate>(_onEmailUpdate);
    on<PasswordUpdate>(_onPasswordUpdate);
    on<PhoneUpdate>(_onPhoneUpdate);
    on<CheckUserExistence>(_onCheckUserExistence);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  void _onNameUpdate(NameUpdate event, Emitter<SignupState> emit) {
    emit(state.copyWith(name: NameInputValidator.dirty(event.name), errorMessage: null));
  }

  void _onEmailUpdate(EmailUpdate event, Emitter<SignupState> emit) {
    emit(state.copyWith(email: EmailOtpInputValidator.dirty(event.email), errorMessage: null));
  }

  void _onPhoneUpdate(PhoneUpdate event, Emitter<SignupState> emit) {
    emit(state.copyWith(phone: PhoneInputValidator.dirty(event.phone), errorMessage: null));
  }

  void _onPasswordUpdate(PasswordUpdate event, Emitter<SignupState> emit) {
    emit(state.copyWith(password: PasswordInputValidator.dirty(event.password), errorMessage: null));
  }

  void _onTogglePasswordVisibility(TogglePasswordVisibility event, Emitter<SignupState> emit) {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void _onCheckUserExistence(CheckUserExistence event, Emitter<SignupState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(showValidationError: true, errorMessage: null));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final result = await _fetchUserExistenceUseCase.call(UserParams(identifier: state.phone.value));

    result.when(
      success: (data) {
        final isExist = data.exists;

        if (isExist) {
          emit(state.copyWith(isSubmitting: false, errorMessage: 'Phone number already exist'));
        } else {
          _onSignupSubmitted(emit);
        }
      },
      failure: (error) {
        final message = switch (error.message) {
          LocaleKeyMessage(:final key) => key.name,
          RawStringMessage(:final value) => value,
        };
        emit(state.copyWith(isSubmitting: false, errorMessage: message));
      },
    );
  }

  void _onSignupSubmitted(Emitter<SignupState> emit) async {
    if (!state.isValid) {
      emit(state.copyWith(showValidationError: true, errorMessage: null));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    if (!state.isValid) {
      emit(state.copyWith(isSubmitting: false, errorMessage: 'Please fill in all required fields.'));
      return;
    }

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Success simulation
    emit(state.copyWith(isSubmitting: false, isSuccess: true));
  }
}

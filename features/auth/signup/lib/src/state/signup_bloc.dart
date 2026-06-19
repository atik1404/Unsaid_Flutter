import 'package:common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signup/src/state/signup_event.dart';
import 'package:signup/src/state/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(const SignupState()) {
    on<NameUpdate>(_onNameUpdate);
    on<EmailUpdate>(_onEmailUpdate);
    on<PasswordUpdate>(_onPasswordUpdate);
    on<PhoneUpdate>(_onPhoneUpdate);
    on<SignupSubmitted>(_onSignupSubmitted);
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

  void _onSignupSubmitted(SignupSubmitted event, Emitter<SignupState> emit) async {
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

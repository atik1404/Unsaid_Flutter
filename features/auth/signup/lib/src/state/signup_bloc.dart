import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:signup/src/state/signup_event.dart';
import 'package:signup/src/state/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase _signupUseCase;

  SignupBloc({required SignupUseCase signupUsecase}) : _signupUseCase = signupUsecase, super(const SignupState()) {
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

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress, errorMessage: null));

    final result = await _signupUseCase.call(SignupParams(email: state.email.value, password: state.password.value, phone: state.phone.value, fullname: state.name.value));

    result.when(
      success: (data) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      },
      failure: (failure) {
        final message = switch (failure.message) {
          LocaleKeyMessage(:final key) => key.name,
          RawStringMessage(:final value) => value,
        };
        emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: message));
      },
    );
  }
}

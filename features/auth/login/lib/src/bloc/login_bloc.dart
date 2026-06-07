import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:login/src/bloc/login_event.dart';
import 'package:login/src/bloc/login_state.dart';

/// Orchestrates the login flow: validates form inputs via Formz and
/// delegates authentication to [LoginUseCase].
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc({required LoginUseCase loginUseCase}) : _loginUseCase = loginUseCase, super(const LoginState()) {
    on<LoginPhoneChanged>(_onPhoneChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginTogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  // ── Field change handlers ─────────────────────────────────────────────────
  void _onPhoneChanged(LoginPhoneChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(phone: PhoneInputValidator.dirty(event.phone), errorMessage: null));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(password: PasswordInputValidator.dirty(event.password), errorMessage: null));
  }

  void _onTogglePasswordVisibility(LoginTogglePasswordVisibility event, Emitter<LoginState> emit) {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  // ── Submission ────────────────────────────────────────────────────────────
  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    // Re-dirty both inputs so validators run on the current values.
    final phone = PhoneInputValidator.dirty(state.phone.value);
    final password = PasswordInputValidator.dirty(state.password.value);

    // showErrors = true makes the UI display inline validation messages.
    emit(state.copyWith(phone: phone, password: password, showErrors: true));

    // Abort early if validation fails — the UI already shows the errors.
    if (!state.isValid) return;

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );

    final result = await _loginUseCase(
      LoginParams(identifier: phone.value.formatPhone(), password: password.value),
    );

    result.when(
      success: (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      },
      failure: (failure) {
        // Translate the domain Failure into a displayable string.
        final message = switch (failure.message) {
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

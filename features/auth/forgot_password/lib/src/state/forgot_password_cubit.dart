import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forgot_password/src/state/forgot_password_state.dart';
import 'package:formz/formz.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final FetchUserExistenceUseCase _fetchUserExistenceUseCase;
  final SendOtpUseCase _sendOtpUseCase;

  ForgotPasswordCubit({
    required FetchUserExistenceUseCase fetchUserExistenceUseCase,
    required SendOtpUseCase sendOtpUseCase,
  }) : _fetchUserExistenceUseCase = fetchUserExistenceUseCase,
       _sendOtpUseCase = sendOtpUseCase,
       super(const ForgotPasswordState());

  void updatePhone(String phone) {
    final phoneInput = PhoneInputValidator.dirty(phone);
    emit(state.copyWith(phone: phoneInput, errorMessage: null));
  }

  Future<void> checkUserExistence() async {
    // Re-dirty the input so the validator runs on the current value, and flip
    // `showError` so the UI reveals inline validation messages from now on.
    final phone = PhoneInputValidator.dirty(state.phone.value);
    emit(state.copyWith(phone: phone, showError: true));

    // Abort early on invalid input — the UI already shows the error.
    if (!state.phone.isValid) return;

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );

    final result = await _fetchUserExistenceUseCase(
      UserParams(identifier: state.phone.value.formatPhone()),
    );

    result.when(
      success: (data) => {
        if (data.exists)
          {_sendOtp(state.phone.value.formatPhone())}
        else
          {
            emit(
              state.copyWith(
                status: FormzSubmissionStatus.failure,
                errorMessage: 'User with this phone number does not exist',
              ),
            ),
          },
      },
      failure: (error) {
        var message = switch (error.message) {
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

  Future<void> _sendOtp(String phone) async {
    final result = await _sendOtpUseCase(phone);

    result.when(
      success: (data) => emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          accountId: data.accountId,
          errorMessage: null,
        ),
      ),
      failure: (error) {
        var message = switch (error.message) {
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

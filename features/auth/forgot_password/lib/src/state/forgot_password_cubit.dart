import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forgot_password/src/state/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final FetchUserExistenceUseCase _fetchUserExistenceUseCase;
  final SendOtpUseCase _sendOtpUseCase;

  ForgotPasswordCubit({required FetchUserExistenceUseCase fetchUserExistenceUseCase, required SendOtpUseCase sendOtpUseCase})
    : _fetchUserExistenceUseCase = fetchUserExistenceUseCase,
      _sendOtpUseCase = sendOtpUseCase,
      super(const ForgotPasswordState());

  void updatePhone(String phone) {
    final phoneInput = PhoneInputValidator.dirty(phone);
    emit(state.copyWith(phone: phoneInput, errorMessage: null));
  }

  Future<void> checkUserExistence() async {
    final phoneInput = PhoneInputValidator.dirty(state.phone.value);
    emit(state.copyWith(phone: phoneInput, errorMessage: null, showError: true));

    if (!phoneInput.isValid) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final result = await _fetchUserExistenceUseCase(UserParams(identifier: phoneInput.value.formatPhone()));

    result.when(
      success: (data) => {
        if (data.exists)
          {_sendOtp(phoneInput.value.formatPhone())}
        else
          {emit(state.copyWith(isSubmitting: false, errorMessage: 'User with this phone number does not exist'))},
      },
      failure: (error) {
        var message = switch (error.message) {
          RawStringMessage(:final value) => value,
          LocaleKeyMessage(:final key) => key.name,
        };

        emit(state.copyWith(isSubmitting: false, errorMessage: message));
      },
    );
  }

  Future<void> _sendOtp(String phone) async {
    final result = await _sendOtpUseCase(phone);

    result.when(
      success: (data) => emit(state.copyWith(isSubmitting: false, isSuccess: true, accountId: data.accountId, errorMessage: null)),
      failure: (error) {
        var message = switch (error.message) {
          RawStringMessage(:final value) => value,
          LocaleKeyMessage(:final key) => key.name,
        };

        emit(state.copyWith(isSubmitting: false, errorMessage: message));
      },
    );
  }
}

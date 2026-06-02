import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forgot_password/src/state/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final FetchUserExistenceUseCase fetchUserExistenceUseCase;

  ForgotPasswordCubit(this.fetchUserExistenceUseCase) : super(const ForgotPasswordState());

  void updatePhone(String phone) {
    final phoneInput = PhoneInputValidator.dirty(phone);
    emit(state.copyWith(phone: phoneInput, errorMessage: null));
  }

  Future<void> checkUserExistence() async {
    final phoneInput = PhoneInputValidator.dirty(state.phone.value);
    emit(state.copyWith(phone: phoneInput, errorMessage: null, showError: true));

    if (!phoneInput.isValid) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final result = await fetchUserExistenceUseCase(UserParams(identifier: phoneInput.value.formatPhone()));

    result.when(
      success: (data) => {
        if (!data.exists)
          {
            AppLog.log('User does not exist, sending OTP'),
            //_sendOtp(phoneInput.value.formatPhone())
            emit(state.copyWith(isSubmitting: false, errorMessage: 'User with this phone number does not exist')),
          }
        else
          {emit(state.copyWith(isSubmitting: false, isSuccess: true))},
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
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forgot_password/src/state/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  void updatePhone(String phone) {
    emit(state.copyWith(phone: phone, errorMessage: null));
  }

  Future<void> sendOtp() async {
    if (state.phone.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'empty_phone'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(isSubmitting: false, isSuccess: true));
  }
}

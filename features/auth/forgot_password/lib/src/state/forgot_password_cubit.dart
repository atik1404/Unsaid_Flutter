import 'package:common/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forgot_password/src/state/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  void updatePhone(String phone) {
    final phoneInput = PhoneInputValidator.dirty(phone);
    emit(state.copyWith(phone: phoneInput, errorMessage: null));
  }

  Future<void> sendOtp() async {
    final phoneInput = PhoneInputValidator.dirty(state.phone.value);
    emit(state.copyWith(phone: phoneInput, errorMessage: null, showError: true));

    if (!phoneInput.isValid) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final phoneNumber = state.phone.value.formatPhone();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (_) {},
      verificationFailed: (FirebaseAuthException e) {
        if (isClosed) return;
        emit(state.copyWith(isSubmitting: false, errorMessage: e.message));
      },
      codeSent: (String verificationId, int? resendToken) {
        if (isClosed) return;
        emit(state.copyWith(isSubmitting: false, isSuccess: true, verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<void> checkUser() async {}
}

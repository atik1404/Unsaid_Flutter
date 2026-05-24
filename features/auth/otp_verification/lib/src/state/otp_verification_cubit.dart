import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_verification/src/state/otp_verification_state.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  Timer? _timer;

  OtpVerificationCubit({required String verificationId, required String phone})
      : super(OtpVerificationState(verificationId: verificationId, phone: phone)) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    emit(state.copyWith(timerSeconds: 60, canResend: false));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      if (state.timerSeconds <= 1) {
        timer.cancel();
        emit(state.copyWith(timerSeconds: 0, canResend: true));
      } else {
        emit(state.copyWith(timerSeconds: state.timerSeconds - 1));
      }
    });
  }

  void updateOtp(String otp) {
    emit(state.copyWith(otp: otp, errorMessage: null));
  }

  Future<void> resendOtp() async {
    if (!state.canResend) return;
    emit(state.copyWith(otp: '', errorMessage: null));

    final phoneNumber = '+88${state.phone}';

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (_) {},
      verificationFailed: (FirebaseAuthException e) {
        if (isClosed) return;
        emit(state.copyWith(errorMessage: e.message));
      },
      codeSent: (String verificationId, int? resendToken) {
        if (isClosed) return;
        emit(state.copyWith(verificationId: verificationId));
        _startTimer();
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<void> verify() async {
    if (state.otp.length < 6) {
      emit(state.copyWith(errorMessage: 'incomplete'));
      return;
    }

    emit(state.copyWith(isVerifying: true, errorMessage: null));

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: state.verificationId,
        smsCode: state.otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (isClosed) return;
      emit(state.copyWith(isVerifying: false, isSuccess: true));
    } on FirebaseAuthException catch (e) {
      if (isClosed) return;
      final errorMessage = e.code == 'invalid-verification-code' ? 'invalid' : (e.message ?? 'unknown_error');
      emit(state.copyWith(isVerifying: false, errorMessage: errorMessage));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

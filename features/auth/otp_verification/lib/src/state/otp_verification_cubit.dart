import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_verification/src/state/otp_verification_state.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  Timer? _timer;

  OtpVerificationCubit() : super(const OtpVerificationState()) {
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

  void resendOtp() {
    if (!state.canResend) return;
    emit(state.copyWith(otp: '', errorMessage: null));
    _startTimer();
  }

  Future<void> verify() async {
    if (state.otp.length < 6) {
      emit(state.copyWith(errorMessage: 'incomplete'));
      return;
    }

    emit(state.copyWith(isVerifying: true, errorMessage: null));

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (isClosed) return;

    // Simulate invalid OTP (any code other than '000000' succeeds)
    if (state.otp == '000000') {
      emit(state.copyWith(isVerifying: false, errorMessage: 'invalid'));
      return;
    }

    emit(state.copyWith(isVerifying: false, isSuccess: true));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

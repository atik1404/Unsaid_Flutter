import 'dart:async';
import 'package:common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_verification/src/state/otp_verification_state.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  Timer? _timer;
  final AnalyticsTracker _analytics;

  OtpVerificationCubit({
    required String verificationId,
    required String phone,
    required this._analytics,
  }) : super(
         OtpVerificationState(verificationId: verificationId, phone: phone),
       ) {
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
    _startTimer();
  }

  Future<void> verifyOtp() async {
    // Reject submission until every digit of the code has been entered.
    if (state.otp.length < AppConstants.otpLength) {
      emit(state.copyWith(errorMessage: 'incomplete'));
      return;
    }

    emit(state.copyWith(isVerifying: true, errorMessage: null));

    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    emit(state.copyWith(isVerifying: false, isSuccess: true));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

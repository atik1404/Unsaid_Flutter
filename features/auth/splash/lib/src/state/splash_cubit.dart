import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sharedpref/sharedpref.dart';
import 'package:common/common.dart';
import 'package:splash/src/state/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final sharedPref = GetIt.I.get<SharedPrefManager>();

  SplashCubit() : super(const SplashState.initial()) {
    Future.microtask(checkAuthorization);
  }

  Future<void> checkAuthorization() async {
    emit(const SplashState.loading());

    final isAuthorized = sharedPref.getBool(SharedPrefKeys.isAuthorized);
    final isIntroScreenVisible = sharedPref.getBool(
      SharedPrefKeys.introScreenVisibility,
    );

    if (isAuthorized == true) {
      fetchProfile();
    } else {
      if (!isIntroScreenVisible) {
        emit(const SplashState.navigateToOnboarding());
      } else {
        emit(const SplashState.navigateToLogin());
      }
    }
  }

  Future<void> fetchProfile() async {
    emit(const SplashState.loading());
    try {
      await Future.delayed(const Duration(seconds: 3));
      emit(const SplashState.navigateToHome());
    } catch (e) {
      emit(SplashState.error(message: e.toString()));
    }
  }
}

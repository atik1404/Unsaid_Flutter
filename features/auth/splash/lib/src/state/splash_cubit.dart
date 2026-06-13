import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:navigation/navigation.dart';
import 'package:pref_storage/pref_storage.dart';
import 'package:splash/src/state/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final _prefStorage = GetIt.I.get<AppPrefStorage>();

  SplashCubit() : super(const SplashState.loading()) {
    Future.microtask(checkAuthorization);
  }

  void checkAuthorization() async {
    emit(const SplashState.loading());

    final isAuthorized = _prefStorage.getBoolean(PrefKey.loginStatus);
    final isIntroScreenVisible = _prefStorage.getBoolean(PrefKey.isFirstLaunch);

    await Future.delayed(const Duration(seconds: 3));

    if (isAuthorized) {
      fetchProfile();
    } else {
      if (!isIntroScreenVisible) {
        emit(const SplashState.navigateToNextScreen(redirect: AppRouteName.onboardingScreen));
      } else {
        emit(const SplashState.navigateToNextScreen(redirect: AppRouteName.homeScreen));
      }
    }
  }

  Future<void> fetchProfile() async {
    emit(const SplashState.loading());
    try {
      await Future.delayed(const Duration(seconds: 3));
      emit(const SplashState.navigateToNextScreen(redirect: AppRouteName.homeScreen));
    } catch (e) {
      emit(SplashState.error(message: e.toString()));
    }
  }
}

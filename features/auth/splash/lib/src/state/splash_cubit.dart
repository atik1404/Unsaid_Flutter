import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pref_storage/pref_storage.dart';
import 'package:splash/src/state/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final _authStorageRepo = GetIt.I.get<AuthStorageRepository>();

  SplashCubit() : super(const SplashState.initial()) {
    Future.microtask(checkAuthorization);
  }

  void checkAuthorization() async {
    emit(const SplashState.loading());

    final isAuthorized = await _authStorageRepo.getLoginStatus();
    final isIntroScreenVisible = await _authStorageRepo.getFirstLaunch();

    await Future.delayed(const Duration(seconds: 3));
    emit(const SplashState.navigateToOnboarding());

    if (isAuthorized) {
      //fetchProfile();
    } else {
      if (!isIntroScreenVisible) {
        //emit(const SplashState.navigateToOnboarding());
      } else {
        //emit(const SplashState.navigateToLogin());
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

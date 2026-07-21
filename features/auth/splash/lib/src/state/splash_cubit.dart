import 'package:common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:navigation/navigation.dart';
import 'package:pref_storage/pref_storage.dart';
import 'package:splash/src/state/splash_state.dart';
import 'package:domain/domain.dart';

class SplashCubit extends Cubit<SplashState> {
  final FetchProfileUseCase _fetchProfileUseCase;
  final _prefStorage = GetIt.I.get<AppPrefStorage>();

  SplashCubit({required FetchProfileUseCase fetchProfileUseCase})
    : _fetchProfileUseCase = fetchProfileUseCase,
      super(const SplashState.loading()) {
    Future.microtask(checkAuthorization);
  }

  void checkAuthorization() async {
    emit(const SplashState.loading());

    final isAuthorized = _prefStorage.getBoolean(PrefKey.loginStatus);
    final isIntroScreenVisible = _prefStorage.getBoolean(PrefKey.isFirstLaunch);

    if (isAuthorized) {
      await _fetchProfile();
    } else {
      await Future.delayed(const Duration(seconds: 2));
      if (!isIntroScreenVisible) {
        emit(
          const SplashState.navigateToNextScreen(
            redirect: AppRouteName.onboardingScreen,
          ),
        );
      } else {
        emit(
          const SplashState.navigateToNextScreen(
            redirect: AppRouteName.homeScreen,
          ),
        );
      }
    }
  }

  Future<void> _fetchProfile() async {
    emit(const SplashState.loading());

    final result = await _fetchProfileUseCase();

    result.when(
      success: (data) {
        emit(
          const SplashState.navigateToNextScreen(
            redirect: AppRouteName.homeScreen,
          ),
        );
      },
      failure: (failure) {
        final message = switch (failure.message) {
          RawStringMessage(:final value) => value,
          LocaleKeyMessage(:final key) => key.name,
        };
        emit(
          SplashState.error(message: message),
        );
      },
    );
  }
}

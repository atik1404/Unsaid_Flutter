import "package:freezed_annotation/freezed_annotation.dart";

part 'splash_state.freezed.dart';

@freezed
sealed class SplashState with _$SplashState {
  const factory SplashState.initial() = SplashInitial;
  const factory SplashState.loading() = SplashLoading;
  const factory SplashState.navigateToHome() = SplashNavigateToHome;
  const factory SplashState.navigateToOnboarding() = SplashNavigateToOnboarding;
  const factory SplashState.navigateToLogin() = SplashNavigateToLogin;
  const factory SplashState.error({required String message}) = SplashError;
}

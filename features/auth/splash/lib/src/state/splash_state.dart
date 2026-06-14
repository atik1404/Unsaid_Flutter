import "package:freezed_annotation/freezed_annotation.dart";

part 'splash_state.freezed.dart';

@freezed
sealed class SplashState with _$SplashState {
  const factory SplashState.loading() = SplashLoading;
  const factory SplashState.navigateToNextScreen({required String redirect}) = SplashNavigateToNextScreen;
  const factory SplashState.error({required String message}) = SplashError;
}

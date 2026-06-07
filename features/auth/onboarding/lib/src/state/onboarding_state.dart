import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

/// Immutable state for [OnboardingCubit].
///
/// Tracks which page the user is on and whether navigation to the next screen
/// has been requested. Defaults represent the very first launch of the flow.
@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    /// Whether the user has reached the last onboarding page.
    @Default(false) bool isLastPage,

    /// Signals the screen to navigate away once the user taps "Get Started".
    /// Reset to `false` immediately after navigation so the state is reusable.
    @Default(false) bool shouldNavigateToNextScreen,

    /// Zero-based index of the currently visible page.
    @Default(0) int currentPage,
  }) = _OnboardingState;
}

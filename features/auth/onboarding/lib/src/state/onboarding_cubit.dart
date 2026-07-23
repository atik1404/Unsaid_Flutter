import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding/src/state/onboarding_state.dart';
import 'package:pref_storage/pref_storage.dart';

/// Business logic for the onboarding flow.
///
/// Responsibilities:
/// - Track the current page as the user swipes through the pager.
/// - Persist the "first launch completed" flag so the app skips onboarding
///   on subsequent launches.
/// - Emit the navigation signal that tells the screen to go to login.
class OnboardingCubit extends Cubit<OnboardingState> {
  final AppPrefStorage _prefStorage;

  /// Creates an [OnboardingCubit].
  ///
  /// [_prefStorage] is used to persist the first-launch flag when the user
  /// completes onboarding.
  OnboardingCubit({
    required this._prefStorage,
  }) : super(const OnboardingState());

  /// Called whenever the [PageView] page changes.
  ///
  /// Updates [OnboardingState.currentPage] and flips [OnboardingState.isLastPage]
  /// so the UI can reveal the "Get Started" button on the final page.
  void onPageChanged({required int index, required int totalPages}) {
    final isLastPage = index == totalPages - 1;

    emit(
      state.copyWith(
        isLastPage: isLastPage,
        currentPage: index,
      ),
    );
  }

  /// Marks onboarding as completed and requests navigation to the login screen.
  ///
  /// Persists [AppPrefStorage.write] so the splash screen
  /// can redirect directly to login on subsequent launches.
  void navigateToHomeScreen() {
    _prefStorage.write(PrefKey.isFirstLaunch, true);
    emit(state.copyWith(shouldNavigateToNextScreen: true));
  }
}

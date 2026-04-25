import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding/src/state/onboarding_state.dart';
import 'package:sharedpref/sharedpref.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SharedPrefManager _sharedPrefs;

  OnboardingCubit({
    required SharedPrefManager sharedPrefs,
  }) : _sharedPrefs = sharedPrefs,
       super(const OnboardingState());

  void onPageChanged({required int index, required int totalPages}) {
    final isLastPage = index == totalPages - 1;

    emit(
      state.copyWith(
        isLastPage: isLastPage,
        currentPage: index,
      ),
    );
  }

  void navigateToNextScreen() {
    _sharedPrefs.setBool(SharedPrefKeys.introScreenVisibility, value: true);
    emit(state.copyWith(shouldNavigateToNextScreen: true));
  }

  void resetState() {
    emit(const OnboardingState());
  }
}

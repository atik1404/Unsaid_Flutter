import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding/src/state/onboarding_state.dart';
import 'package:pref_storage/pref_storage.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final AuthStorageRepository _repository;

  OnboardingCubit({
    required AuthStorageRepository repository,
  }) : _repository = repository,
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
    _repository.saveFirstLaunch(true);
    emit(state.copyWith(shouldNavigateToNextScreen: true));
  }

  void resetState() {
    emit(const OnboardingState());
  }
}

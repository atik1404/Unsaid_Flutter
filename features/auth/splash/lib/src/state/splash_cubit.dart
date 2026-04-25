import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splash/src/state/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState.initial());

  Future<void> initialize() async {
    emit(const SplashState.loading());
    try {
      await Future.delayed(const Duration(seconds: 3));
      emit(const SplashState.success());
    } catch (e) {
      emit(SplashState.error(message: e.toString()));
    }
  }
}

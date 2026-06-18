import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signup/src/state/signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(const SignupState());

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updatePhone(String phone) {
    emit(state.copyWith(phone: phone));
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  /// Toggles the obscured/visible state of the password field.
  ///
  /// Kept in state (rather than local widget state) so the UI stays a pure
  /// function of the cubit, mirroring the login feature.
  void togglePasswordVisibility() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void submit() async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (state.name.isEmpty || state.phone.isEmpty || state.password.isEmpty) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Please fill in all required fields.',
      ));
      return;
    }

    // Success simulation
    emit(state.copyWith(isSubmitting: false, isSuccess: true));
  }
}

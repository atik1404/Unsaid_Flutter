/// All events the [LoginBloc] can receive.
sealed class LoginEvent {
  const LoginEvent();
}

/// Fired on every keystroke in the phone number field.
final class LoginPhoneChanged extends LoginEvent {
  const LoginPhoneChanged(this.phone);

  final String phone;
}

/// Fired on every keystroke in the password field.
final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;
}

/// Fired when the user taps the "Login" button.
///
/// This event triggers form validation (making errors visible) and,
/// if valid, calls the [LoginUseCase].
final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

final class LoginTogglePasswordVisibility extends LoginEvent {
  const LoginTogglePasswordVisibility();
}

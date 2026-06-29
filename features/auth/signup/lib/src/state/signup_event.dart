sealed class SignupEvent {
  const SignupEvent();
}

final class NameUpdate extends SignupEvent {
  const NameUpdate(this.name);

  final String name;
}

final class EmailUpdate extends SignupEvent {
  const EmailUpdate(this.email);

  final String email;
}

final class PasswordUpdate extends SignupEvent {
  const PasswordUpdate(this.password);

  final String password;
}

final class PhoneUpdate extends SignupEvent {
  const PhoneUpdate(this.phone);

  final String phone;
}

final class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();
}

final class TogglePasswordVisibility extends SignupEvent {
  const TogglePasswordVisibility();
}
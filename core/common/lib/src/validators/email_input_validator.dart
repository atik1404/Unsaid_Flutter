import 'package:formz/formz.dart';
import 'package:common/src/enums/validation_error.dart';

/// Formz input that validates an 11-digit phone number.
class EmailInputValidator extends FormzInput<String, ValidationError> {
  const EmailInputValidator.pure() : super.pure('');
  const EmailInputValidator.dirty([super.value = '']) : super.dirty();

  //email regex for validation
  static final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  ValidationError? validator(String value) {
    if (value.isEmpty) return ValidationError.empty;
    if (!_emailRegex.hasMatch(value)) return ValidationError.invalid;
    return null;
  }
}

class EmailOtpInputValidator extends FormzInput<String, ValidationError> {
  const EmailOtpInputValidator.pure() : super.pure('');
  const EmailOtpInputValidator.dirty([super.value = '']) : super.dirty();

  //email regex for validation
  static final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  ValidationError? validator(String value) {
    if (value.isEmpty) return null;
    if (!_emailRegex.hasMatch(value)) return ValidationError.invalid;
    return null;
  }
}

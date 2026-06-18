import 'package:formz/formz.dart';
import 'package:common/src/enums/validation_error.dart';

/// Formz input that validates an 11-digit phone number.
class EmailInputValidator extends FormzInput<String, ValidationError> {
  const EmailInputValidator.pure() : super.pure('');
  const EmailInputValidator.dirty([super.value = '']) : super.dirty();

  // Matches exactly 11 consecutive digits (e.g. 01XXXXXXXXX).
  static final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  ValidationError? validator(String value) {
    if (value.isEmpty) return ValidationError.empty;
    if (!_emailRegex.hasMatch(value)) return ValidationError.invalid;
    return null;
  }
}

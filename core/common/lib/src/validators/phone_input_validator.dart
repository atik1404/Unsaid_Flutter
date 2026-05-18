import 'package:formz/formz.dart';
import 'package:common/src/enums/validation_error.dart';

/// Formz input that validates an 11-digit phone number.
class PhoneInputValidator extends FormzInput<String, ValidationError> {
  const PhoneInputValidator.pure() : super.pure('');
  const PhoneInputValidator.dirty([super.value = '']) : super.dirty();

  // Matches exactly 11 consecutive digits (e.g. 01XXXXXXXXX).
  static final _phoneRegex = RegExp(r'^\d{11}$');

  @override
  ValidationError? validator(String value) {
    if (value.isEmpty) return ValidationError.empty;
    if (!_phoneRegex.hasMatch(value)) return ValidationError.invalid;
    return null;
  }
}


import 'package:common/src/enums/failure_key.dart';

sealed class FailureMessage {
  const FailureMessage();
}

class LocaleKeyMessage extends FailureMessage {
  final FailureKey key;
  const LocaleKeyMessage(this.key);
}

class RawStringMessage extends FailureMessage {
  final String value;
  const RawStringMessage(this.value);
}

import 'package:common/src/enums/failure_key.dart';
import 'package:common/src/result/failure_message.dart';

sealed class Failure {
  int? get statusCode;
  FailureMessage get message;

  const Failure();
}

class NetworkFailure extends Failure {
  final FailureKey errorKey;
  const NetworkFailure(this.errorKey, this.statusCode);

  @override
  final int? statusCode;

  @override
  FailureMessage get message => LocaleKeyMessage(errorKey);
}

class ServerFailure extends Failure {
  final String rawMessage;
  const ServerFailure(this.rawMessage, this.statusCode);

  @override
  final int? statusCode;

  @override
  FailureMessage get message => RawStringMessage(rawMessage);
}

class ParseFailure extends Failure {
  final FailureKey errorKey;
  final String debugMessage;

  const ParseFailure(this.errorKey, this.debugMessage);

  @override
  int? get statusCode => null;

  @override
  FailureMessage get message => LocaleKeyMessage(errorKey);
}

class UnknownFailure extends Failure {
  final FailureKey errorKey;
  const UnknownFailure(this.errorKey, this.statusCode);

  @override
  final int? statusCode;

  @override
  FailureMessage get message => LocaleKeyMessage(errorKey);
}

class ValidationFailure extends Failure {
  final FailureKey errorKey;

  const ValidationFailure(this.errorKey);

  @override
  int? get statusCode => null;

  @override
  FailureMessage get message => LocaleKeyMessage(errorKey);
}

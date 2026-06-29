import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

extension FailureResolver on Failure {
  String resolveMessage(BuildContext context) {
    return switch (message) {
      LocaleKeyMessage(:final key) => key.locale(context),
      RawStringMessage(:final value) => value,
    };
  }
}

extension FailureMessageResolver on FailureMessage {
  String resolveMessage(BuildContext context) {
    return switch (this) {
      LocaleKeyMessage(:final key) => key.locale(context),
      RawStringMessage(:final value) => value,
    };
  }
}

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:localization/app_locale.dart';

extension AppLocaleKeyExtension on FailureKey {
  String locale(BuildContext context, {List<String>? args}) {
    final l10n = AppLocale.of(context);
    if (l10n == null) {
      return '';
    }
    return switch (this) {
      FailureKey.network => l10n.message_no_internet,
      FailureKey.connectionTimeout => l10n.message_connection_timeout,
      FailureKey.unknown => l10n.message_unknown_error,
      FailureKey.server => l10n.message_something_went_wrong,
      FailureKey.internet => l10n.message_unknown_error,
      FailureKey.authentication => l10n.message_unknown_error,
      FailureKey.validation => l10n.message_unknown_error,
      FailureKey.sessionExpired => l10n.message_unknown_error,
      FailureKey.permissionDenied => l10n.message_unknown_error,
      FailureKey.notFound => l10n.message_unknown_error,
      FailureKey.rateLimitExceeded => l10n.message_unknown_error,
    };
  }
}

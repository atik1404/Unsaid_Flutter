import 'package:flutter/material.dart';
import 'package:localization/app_locale.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocale get l10n => AppLocale.of(this)!;
}

import 'package:designsystem/src/components/button/app_button_colors.dart';

sealed class AppButtonIntent {
  const AppButtonIntent();

  const factory AppButtonIntent.primary() = AppButtonIntentPrimary._;
  const factory AppButtonIntent.custom(AppButtonVariantSet varients) =
      AppButtonIntentCustom._;
}

final class AppButtonIntentPrimary extends AppButtonIntent {
  const AppButtonIntentPrimary._();
}

final class AppButtonIntentCustom extends AppButtonIntent {
  final AppButtonVariantSet variants;
  const AppButtonIntentCustom._(this.variants);
}

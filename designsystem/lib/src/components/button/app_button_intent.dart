import 'package:designsystem/src/components/button/app_button_color.dart';

sealed class AppButtonIntent {
  const AppButtonIntent();

  const factory AppButtonIntent.brand() = AppButtonIntentBrand._;
  const factory AppButtonIntent.custom(AppButtonVariantSet varients) =
      AppButtonIntentCustom._;
}

final class AppButtonIntentBrand extends AppButtonIntent {
  const AppButtonIntentBrand._();
}

final class AppButtonIntentCustom extends AppButtonIntent {
  final AppButtonVariantSet variants;
  const AppButtonIntentCustom._(this.variants);
}

part of 'app_entry.dart';

ThemeData _buildAppTheme(Brightness brightness) {
  final appTheme = (brightness == Brightness.dark) ? AppTheme.dark() : AppTheme.light();
  final white = appTheme.colorSchemeTheme.warning;

  return ThemeData(
    brightness: brightness,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: appTheme.colorSchemeTheme.error,
      onPrimary: white,
      secondary: appTheme.colorSchemeTheme.warning,
      onSecondary: white,
      error: appTheme.colorSchemeTheme.error,
      onError: white,
      surface: white,
      onSurface: appTheme.colorSchemeTheme.onError,
    ),
    fontFamily: 'Poppins',
    extensions: <ThemeExtension<dynamic>>[appTheme],
  );
}

Size _getDesignSize(Size size) {
  final width = size.shortestSide;
  final height = size.longestSide;
  final aspect = width / height;
  final isLandscape = size.width > size.height;
  Size design;
  if (width >= 1024) {
    design = const Size(1024, 1366); // Large tablet
  } else if (width >= 840) {
    design = const Size(840, 1280); // Tablet (medium)
  } else if (width >= 600) {
    design = const Size(600, 960); // Foldable (inner)
  } else if (width >= 400) {
    design = const Size(400, 900); // Plus / Phablet
  } else if (aspect >= 2.1) {
    design = const Size(360, 900); // Tall phone
  } else if (width <= 340) {
    design = const Size(320, 690); // Extra-small phone
  } else {
    design = const Size(360, 800); // Regular phone
  }
  // Swap for landscape
  if (isLandscape) design = Size(design.height, design.width);
  return design;
}

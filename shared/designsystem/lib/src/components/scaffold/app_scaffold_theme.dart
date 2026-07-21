import 'package:designsystem/src/tokens/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class AppScaffoldTheme extends ThemeExtension<AppScaffoldTheme> {
  final Color backgroundColor;
  final Gradient? gradientColor;
  final SystemUiOverlayStyle overlayStyle;

  const AppScaffoldTheme({
    required this.backgroundColor,
    required this.overlayStyle,
    this.gradientColor,
  });

  factory AppScaffoldTheme.light() => AppScaffoldTheme(
    backgroundColor: AppColors.neutral50,
    overlayStyle: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: AppColors.transparent,
      systemNavigationBarColor: AppColors.neutral50,
    ),
    gradientColor: const LinearGradient(
      colors: [AppColors.brand700, AppColors.brand400],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  // Note: Not fully implemented because currently I do not need dark mode, but the scope is kept.
  factory AppScaffoldTheme.dark() => AppScaffoldTheme(
    backgroundColor: AppColors.neutral900,
    overlayStyle: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: AppColors.transparent,
      systemNavigationBarColor: AppColors.neutral900,
    ),
    gradientColor: const LinearGradient(
      colors: [AppColors.brand700, AppColors.brand400],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  // Note: Not fully implemented because currently I do not need mutability, but the scope is kept.
  @override
  ThemeExtension<AppScaffoldTheme> copyWith({
    Color? backgroundColor,
    SystemUiOverlayStyle? overlayStyle,
  }) {
    return AppScaffoldTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      overlayStyle: overlayStyle ?? this.overlayStyle,
    );
  }

  // Note: Not fully implemented because currently I do not need smoothness, but the scope is kept.
  @override
  ThemeExtension<AppScaffoldTheme> lerp(
    covariant ThemeExtension<AppScaffoldTheme>? other,
    double t,
  ) => this;
}

import 'package:flutter/material.dart';

enum AppTextWeight {
  thin,
  light,
  regular,
  medium,
  semiBold,
  bold,
  extraBold,
}

extension AppTextWeightX on AppTextWeight {
  FontWeight get fontWeight {
    return switch (this) {
      AppTextWeight.thin => FontWeight.w100,
      AppTextWeight.light => FontWeight.w300,
      AppTextWeight.regular => FontWeight.w400,
      AppTextWeight.medium => FontWeight.w500,
      AppTextWeight.semiBold => FontWeight.w600,
      AppTextWeight.bold => FontWeight.w700,
      AppTextWeight.extraBold => FontWeight.w900,
    };
  }
}

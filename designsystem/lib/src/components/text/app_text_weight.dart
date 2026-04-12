import 'package:flutter/material.dart';

enum AppTextWeight {
  regular,
  medium,
  semiBold,
  bold,
}

extension AppTextWeightX on AppTextWeight {
  FontWeight get fontWeight {
    return switch (this) {
      AppTextWeight.regular => FontWeight.w400,
      AppTextWeight.medium => FontWeight.w500,
      AppTextWeight.semiBold => FontWeight.w600,
      AppTextWeight.bold => FontWeight.w700,
    };
  }
}

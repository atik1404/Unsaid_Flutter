import 'package:flutter/material.dart';

class AppInputFieldColors {
  // Surface
  final Color fill;
  final Color fillDisabled;

  // Borders (by state)
  final Color borderDefault;
  final Color borderHover;
  final Color borderFocused;
  final Color borderError;
  final Color borderErrorFocused;
  final Color borderDisabled;

  // Text
  final Color text;
  final Color textDisabled;
  final Color placeholder;

  // Label
  final Color label;
  final Color labelFocused;
  final Color labelError;
  final Color labelDisabled;

  // Helper / error text
  final Color helper;
  final Color helperError;

  // Icons
  final Color icon;
  final Color iconFocused;
  final Color iconError;
  final Color iconDisabled;

  // Cursor
  final Color cursor;

  const AppInputFieldColors({
    required this.fill,
    required this.fillDisabled,
    required this.borderDefault,
    required this.borderHover,
    required this.borderFocused,
    required this.borderError,
    required this.borderErrorFocused,
    required this.borderDisabled,
    required this.text,
    required this.textDisabled,
    required this.placeholder,
    required this.label,
    required this.labelFocused,
    required this.labelError,
    required this.labelDisabled,
    required this.helper,
    required this.helperError,
    required this.icon,
    required this.iconFocused,
    required this.iconError,
    required this.iconDisabled,
    required this.cursor,
  });
}

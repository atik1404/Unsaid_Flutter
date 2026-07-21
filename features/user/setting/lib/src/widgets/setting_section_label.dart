import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';

/// A small, all-caps heading that introduces a group of setting rows
/// (e.g. "IDENTITY", "PRIVACY").
///
/// Purely presentational: the colour is supplied by the caller so the same
/// widget can render neutral section headers and the red "DANGER ZONE" header.
class SettingSectionLabel extends StatelessWidget {
  /// The heading text. Already localized by the caller.
  final String title;

  /// The text colour, letting callers tint the danger-zone header differently.
  final Color color;

  const SettingSectionLabel({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppText.captionMedium(
      title,
      color: color,
      textWeight: AppTextWeight.light,
    );
  }
}

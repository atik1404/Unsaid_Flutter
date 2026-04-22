import 'package:flutter/material.dart';

/// A flat set of colors for one specific (intent + variant) combination.
/// No fallback logic, no variant-aware fields — just the three colors
/// a tag actually paints with.
@immutable
final class AppTagColors {
  final Color background;
  final Color foreground;
  final Color border;

  const AppTagColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
}

/// All three variants of a single intent, fully specified.
/// This is what designers hand you in Figma: "for the success tag,
/// here's filled, here's outline, here's filled-outline."
@immutable
final class AppTagVariantSet {
  final AppTagColors filled;
  final AppTagColors outline;
  final AppTagColors filledOutline;

  const AppTagVariantSet({
    required this.filled,
    required this.outline,
    required this.filledOutline,
  });

  // Helper for the common case where filled/outline/filledOutline
  /// follow the standard pattern. Use this in the theme to keep
  /// definitions short — but you can always override per-variant.
  factory AppTagVariantSet.standard({
    required Color solid,
    required Color onSolid,
    Color? soft,
    Color? onSoft,
  }) {
    return AppTagVariantSet(
      filled: AppTagColors(
        background: solid,
        foreground: onSolid,
        border: solid,
      ),
      outline: AppTagColors(
        background: Colors.transparent,
        foreground: solid,
        border: solid,
      ),
      filledOutline: AppTagColors(
        background: soft ?? solid.withValues(alpha: 0.12),
        foreground: onSoft ?? solid,
        border: solid,
      ),
    );
  }
}

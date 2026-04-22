import 'package:flutter/material.dart';

/// A flat set of colors for one specific (tone + variant) combination.
class AppCardColors {
  final Color background;
  final Color border;
  final Color shadow;

  const AppCardColors({
    required this.background,
    required this.border,
    required this.shadow,
  });
}

/// All three variants of a single tone, fully specified.
class AppCardVariantSet {
  final AppCardColors filled;
  final AppCardColors outline;
  final AppCardColors filledOutline;

  const AppCardVariantSet({
    required this.filled,
    required this.outline,
    required this.filledOutline,
  });

  /// Standard derivation: pass a [surface] color and [border] color,
  /// optionally override [softSurface] and [shadow]. Soft surface
  /// auto-derives from surface if not provided.
  factory AppCardVariantSet.standard({
    required Color surface,
    required Color border,
    Color? softSurface,
    Color? shadow,
  }) {
    final shadowColor = shadow ?? Colors.black.withValues(alpha: 0.1);
    return AppCardVariantSet(
      filled: AppCardColors(
        background: surface,
        border: Colors.transparent,
        shadow: shadowColor,
      ),
      outline: AppCardColors(
        background: Colors.transparent,
        border: border,
        shadow: Colors.transparent,
      ),
      filledOutline: AppCardColors(
        background: softSurface ?? surface.withValues(alpha: 0.12),
        border: border,
        shadow: shadowColor,
      ),
    );
  }
}

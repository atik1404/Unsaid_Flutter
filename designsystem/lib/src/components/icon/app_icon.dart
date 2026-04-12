import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final Widget source;
  final Color? color;
  final double? size;

  /// If true, recolors all non-transparent pixels of [source] to [color].
  /// If false (default), [source] renders with its original colors —
  /// useful for brand logos, multi-color SVGs, flags, etc.
  final bool tint;

  const AppIcon(
    this.source, {
    super.key,
    this.color,
    this.size,
    this.tint = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final effectiveSize = size ?? iconTheme.size ?? 24;
    final effectiveColor = color ?? iconTheme.color;

    final sized = SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: source,
    );

    if (!tint || effectiveColor == null) {
      return sized;
    }

    return ColorFiltered(
      colorFilter: ColorFilter.mode(effectiveColor, BlendMode.srcIn),
      child: sized,
    );
  }
}

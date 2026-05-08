import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';

class AppTag extends StatelessWidget {
  final AppTagIntent intent;
  final AppTagVariant variant;
  final AppTagShape shape;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final bool tintLeadingTrailing;

  const AppTag({
    super.key,
    this.intent = AppTagIntent.brand,
    this.variant = AppTagVariant.filled,
    this.shape = AppTagShape.pill,
    this.padding,
    required this.child,
    this.leading,
    this.trailing,
    this.tintLeadingTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.tagTheme;
    final variants = theme.byIntent(intent);
    final colors = switch (variant) {
      AppTagVariant.filled => variants.filled,
      AppTagVariant.outline => variants.outline,
      AppTagVariant.filledOutline => variants.filledOutline,
    };

    return Material(
      shape: _resolveShape(colors.border),
      color: colors.background,
      child: Padding(
        padding: padding ?? _defaultPaddingFor(shape),
        child: IconTheme.merge(
          data: IconThemeData(color: colors.foreground, size: 16),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: colors.foreground),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leading != null) ...[
                  _tinted(leading!, colors.foreground),
                  const SizedBox(width: 4),
                ],
                child,
                if (trailing != null) ...[
                  const SizedBox(width: 4),
                  _tinted(trailing!, colors.foreground),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tinted(Widget widget, Color color) {
    if (!tintLeadingTrailing) return widget;
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: widget,
    );
  }

  ShapeBorder _resolveShape(Color borderColor) {
    final side = BorderSide(color: borderColor, width: 1);
    return switch (shape) {
      AppTagShape.pill => StadiumBorder(side: side),
      AppTagShape.rounded => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: side,
      ),
      AppTagShape.circle => CircleBorder(side: side),
      AppTagShape.sharp => RoundedRectangleBorder(
        side: side,
      ),
    };
  }

  EdgeInsetsGeometry _defaultPaddingFor(AppTagShape shape) {
    return switch (shape) {
      AppTagShape.pill => const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      AppTagShape.rounded => const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      AppTagShape.sharp => const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      AppTagShape.circle => const EdgeInsets.all(6),
    };
  }
}

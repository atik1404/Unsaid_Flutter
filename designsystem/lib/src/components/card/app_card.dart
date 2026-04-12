import 'package:designsystem/src/components/card/app_card_enums.dart';
import 'package:designsystem/src/components/card/card.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardTone tone;
  final AppCardVariant variant;
  final AppCardShape _shape;
  final EdgeInsetsGeometry padding;
  final AppCardCornerRadius cornerRadius;
  final AppCardCornerMode cornerMode;
  final double? elevation;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AppCard._({
    required this.child,
    required this.tone,
    required this.variant,
    required AppCardShape shape,
    required this.padding,
    required this.cornerRadius,
    required this.cornerMode,
    this.elevation,
    this.width,
    this.height,
    this.onTap,
    this.onLongPress,
  }) : _shape = shape;

  factory AppCard.rounded({
    required Widget child,
    AppCardTone tone = AppCardTone.warning,
    AppCardVariant variant = AppCardVariant.filled,
    AppCardCornerRadius cornerRadius = AppCardCornerRadius.md,
    AppCardCornerMode cornerMode = AppCardCornerMode.all,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    double? elevation,
    double? width,
    double? height,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return AppCard._(
      tone: tone,
      variant: variant,
      shape: AppCardShape.rounded,
      padding: padding,
      cornerRadius: cornerRadius,
      cornerMode: cornerMode,
      elevation: elevation,
      width: width,
      height: height,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }

  factory AppCard.pill({
    required Widget child,
    AppCardTone tone = AppCardTone.warning,
    AppCardVariant variant = AppCardVariant.filled,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    double? elevation,
    double? width,
    double? height,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return AppCard._(
      tone: tone,
      variant: variant,
      shape: AppCardShape.pill,
      padding: padding,
      cornerRadius: AppCardCornerRadius.md,
      cornerMode: AppCardCornerMode.all,
      width: width,
      height: height,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }

  factory AppCard.circle({
    required Widget child,
    AppCardTone tone = AppCardTone.warning,
    AppCardVariant variant = AppCardVariant.filled,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    double? size,
    double? elevation,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return AppCard._(
      tone: tone,
      variant: variant,
      shape: AppCardShape.circle,
      padding: padding,
      cornerRadius: AppCardCornerRadius.md,
      cornerMode: AppCardCornerMode.all,
      elevation: elevation,
      width: size,
      height: size,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppCardTheme>()!;
    final variants = theme.byTone(tone);
    final colors = switch (variant) {
      AppCardVariant.filled => variants.filled,
      AppCardVariant.outline => variants.outline,
      AppCardVariant.filledOutline => variants.filledOutline,
    };

    final resolvedElevation = elevation ?? theme.defaultElevationFor(tone);
    final shape = _resolveShape(colors.border);
    final isInteractive = onTap != null || onLongPress != null;

    Widget content = Padding(
      padding: padding,
      child: _shape == AppCardShape.circle ? Center(child: child) : child,
    );

    if (isInteractive) {
      content = InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        customBorder: shape,
        child: content,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        clipBehavior: Clip.antiAlias,
        type: MaterialType.card,
        elevation: resolvedElevation,
        color: colors.background,
        shadowColor: colors.shadow,
        shape: shape,
        child: content,
      ),
    );
  }

  ShapeBorder _resolveShape(Color borderColor) {
    final side = borderColor == Colors.transparent
        ? BorderSide.none
        : BorderSide(color: borderColor, width: 1);

    return switch (_shape) {
      AppCardShape.pill => StadiumBorder(side: side),
      AppCardShape.circle => CircleBorder(side: side),
      AppCardShape.rounded => RoundedRectangleBorder(
        borderRadius: _resolveCornerRadius(),
        side: side,
      ),
    };
  }

  BorderRadiusGeometry _resolveCornerRadius() {
    final r = switch (cornerRadius) {
      AppCardCornerRadius.sm => 5.0,
      AppCardCornerRadius.md => 8.0,
      AppCardCornerRadius.lg => 16.0,
    };
    return switch (cornerMode) {
      AppCardCornerMode.all => BorderRadius.circular(r),
      AppCardCornerMode.top => BorderRadius.vertical(top: Radius.circular(r)),
      AppCardCornerMode.bottom => BorderRadius.vertical(
        bottom: Radius.circular(r),
      ),
      AppCardCornerMode.left => BorderRadius.horizontal(
        left: Radius.circular(r),
      ),
      AppCardCornerMode.right => BorderRadius.horizontal(
        right: Radius.circular(r),
      ),
    };
  }
}

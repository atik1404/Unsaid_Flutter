import 'package:designsystem/src/components/divider/app_divider_enums.dart';
import 'package:designsystem/src/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  final AppDividerVariant variant;
  final AppDividerIntent intent;
  final Axis direction;
  final double thickness;
  final double? indent;
  final double? endIndent;
  final Color? colorOverride;

  final double dashWidth;
  final double dotWidth;
  final double gapWidth;

  const AppDivider({
    super.key,
    this.variant = AppDividerVariant.solid,
    this.intent = AppDividerIntent.primary,
    this.direction = Axis.horizontal,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
    this.colorOverride,
    this.dashWidth = 6.0,
    this.dotWidth = 2.0,
    this.gapWidth = 4.0,
  });

  const AppDivider.dashed({
    super.key,
    this.intent = AppDividerIntent.primary,
    this.direction = Axis.horizontal,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
    this.colorOverride,
    this.dashWidth = 6.0,
    this.gapWidth = 4.0,
  }) : variant = AppDividerVariant.dashed,
       dotWidth = 2.0;

  const AppDivider.dotted({
    super.key,
    this.intent = AppDividerIntent.primary,
    this.direction = Axis.horizontal,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
    this.colorOverride,
    this.dotWidth = 2.0,
    this.gapWidth = 4.0,
  }) : variant = AppDividerVariant.dotted,
       dashWidth = 6.0;

  @override
  Widget build(BuildContext context) {
    final theme = context.dividerTheme;
    final color = colorOverride ?? theme.byIntent(intent);

    if (variant == AppDividerVariant.solid) {
      return _buildSolid(color);
    }

    return _buildPatterned(color);
  }

  // ──────────────────────────────────────────────
  // Solid
  // ──────────────────────────────────────────────

  Widget _buildSolid(Color color) {
    final isHorizontal = direction == Axis.horizontal;

    return Padding(
      padding: _resolvePadding(),
      child: SizedBox(
        width: isHorizontal ? double.infinity : thickness,
        height: isHorizontal ? thickness : double.infinity,
        child: ColoredBox(color: color),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Dashed / Dotted
  // ──────────────────────────────────────────────

  Widget _buildPatterned(Color color) {
    final isHorizontal = direction == Axis.horizontal;
    final segmentWidth = variant == AppDividerVariant.dashed
        ? dashWidth
        : dotWidth;

    return Padding(
      padding: _resolvePadding(),
      child: CustomPaint(
        painter: _PatternedDividerPainter(
          color: color,
          thickness: thickness,
          dashWidth: segmentWidth,
          gapWidth: gapWidth,
          direction: direction,
        ),
        size: isHorizontal
            ? const Size(double.infinity, 1)
            : const Size(1, double.infinity),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────

  EdgeInsetsGeometry _resolvePadding() {
    final start = indent ?? 0;
    final end = endIndent ?? 0;

    if (direction == Axis.horizontal) {
      return EdgeInsetsDirectional.only(start: start, end: end);
    }

    return EdgeInsetsDirectional.only(top: start, bottom: end);
  }
}

// ============================================================
// CUSTOM PAINTER (handles both dashed & dotted)
// ============================================================

class _PatternedDividerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double dashWidth;
  final double gapWidth;
  final Axis direction;

  const _PatternedDividerPainter({
    required this.color,
    required this.thickness,
    required this.dashWidth,
    required this.gapWidth,
    required this.direction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final isHorizontal = direction == Axis.horizontal;
    final totalLength = isHorizontal ? size.width : size.height;
    final center = isHorizontal ? size.height / 2 : size.width / 2;

    double current = 0;

    while (current < totalLength) {
      final segmentEnd = (current + dashWidth).clamp(0, totalLength).toDouble();

      final start = isHorizontal
          ? Offset(current, center)
          : Offset(center, current);

      final end = isHorizontal
          ? Offset(segmentEnd, center)
          : Offset(center, segmentEnd);

      canvas.drawLine(start, end, paint);

      current += dashWidth + gapWidth;
    }
  }

  @override
  bool shouldRepaint(covariant _PatternedDividerPainter oldDelegate) {
    return color != oldDelegate.color ||
        thickness != oldDelegate.thickness ||
        dashWidth != oldDelegate.dashWidth ||
        gapWidth != oldDelegate.gapWidth ||
        direction != oldDelegate.direction;
  }
}

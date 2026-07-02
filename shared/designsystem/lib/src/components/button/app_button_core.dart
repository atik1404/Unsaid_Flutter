import 'package:designsystem/src/components/button/button.dart';
import 'package:designsystem/src/components/typography/app_typography_theme.dart';
import 'package:designsystem/src/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

class AppButtonCore extends StatelessWidget {
  const AppButtonCore({
    super.key,
    required this.child,
    required this.variant,
    required this.onPressed,
    this.intent = const AppButtonIntent.primary(),
    this.height = AppButtonHeight.md,
    this.shape = AppButtonShape.rounded,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.width,
    this.padding,
    this.shrinkWrap = false,
  });

  final Widget child;
  final AppButtonVariant variant;
  final VoidCallback? onPressed;
  final AppButtonIntent intent;
  final AppButtonHeight height;
  final AppButtonShape shape;
  final bool isLoading;
  final Widget? leading;
  final Widget? trailing;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;

  static const double _disabledOpacity = .5;
  static const double _hoverOverlayOpacity = 0.08;

  @override
  Widget build(BuildContext context) {
    final theme = context.buttonTheme;
    final typography = context.typography;

    final variants = theme.byIntent(intent);
    final colors = switch (variant) {
      AppButtonVariant.filled => variants.filled,
      AppButtonVariant.outline => variants.outline,
      AppButtonVariant.text => variants.text,
    };

    final dims = _dimensionsFor(height);
    final textStyle = _textStyleFor(height, typography);

    final isInteractive = onPressed != null && !isLoading;
    final hasGradient = variant == AppButtonVariant.filled && colors.gradient != null;

    // Dismiss the soft keyboard on every button press, app-wide.
    final effectiveOnPressed = isLoading ? null : _withKeyboardDismiss(onPressed);

    if (hasGradient) {
      return Opacity(
        opacity: isInteractive ? 1.0 : _disabledOpacity,
        child: SizedBox(
          height: shrinkWrap ? null : dims.height,
          width: width,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              gradient: colors.gradient,
              shape: _resolveShape(),
            ),
            child: ElevatedButton(
              onPressed: effectiveOnPressed,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: colors.foreground,
                disabledBackgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                overlayColor: colors.foreground.withValues(
                  alpha: _hoverOverlayOpacity,
                ),
                shape: _resolveShape(),
                padding: padding,
                tapTargetSize: shrinkWrap ? MaterialTapTargetSize.shrinkWrap : null,
                minimumSize: shrinkWrap ? Size.zero : null,
              ),
              child: _buildChild(
                colors.foreground,
                dims.loadingSize,
                textStyle,
              ),
            ),
          ),
        ),
      );
    }

    final effectiveForeground = isInteractive ? colors.foreground : colors.foreground.withValues(alpha: _disabledOpacity);

    final disabledBackground = variant == AppButtonVariant.filled ? colors.background.withValues(alpha: _disabledOpacity) : Colors.transparent;

    final overlayColor = variant == AppButtonVariant.filled ? null : colors.foreground.withValues(alpha: _hoverOverlayOpacity);

    return SizedBox(
      height: shrinkWrap ? null : dims.height,
      width: width,
      child: ElevatedButton(
        onPressed: effectiveOnPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colors.background,
          foregroundColor: colors.foreground,
          disabledBackgroundColor: isLoading ? colors.background : disabledBackground,
          side: _resolveBorderSide(colors, isInteractive),
          overlayColor: overlayColor,
          shadowColor: Colors.transparent,
          shape: _resolveShape(),
          padding: padding,
          tapTargetSize: shrinkWrap ? MaterialTapTargetSize.shrinkWrap : null,
          minimumSize: shrinkWrap ? Size.zero : null,
        ),
        child: _buildChild(effectiveForeground, dims.loadingSize, textStyle),
      ),
    );
  }

  /// Wraps [callback] so any button tap first dismisses the soft keyboard.
  /// Returns null when there is no callback so the button stays disabled.
  VoidCallback? _withKeyboardDismiss(VoidCallback? callback) {
    if (callback == null) return null;
    return () {
      FocusManager.instance.primaryFocus?.unfocus();
      callback();
    };
  }

  BorderSide? _resolveBorderSide(AppButtonColors colors, bool isInteractive) {
    if (variant != AppButtonVariant.outline) return null;
    final color = isInteractive ? colors.border : colors.border.withValues(alpha: _disabledOpacity);
    return BorderSide(color: color);
  }

  OutlinedBorder _resolveShape() => switch (shape) {
    AppButtonShape.rounded => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    AppButtonShape.pill => const StadiumBorder(),
    AppButtonShape.circle => const CircleBorder(),
    AppButtonShape.sharp => const RoundedRectangleBorder(),
  };

  _ButtonDimensions _dimensionsFor(AppButtonHeight h) => switch (h) {
    AppButtonHeight.sm => const _ButtonDimensions(height: 32, loadingSize: 12),
    AppButtonHeight.md => const _ButtonDimensions(height: 48, loadingSize: 16),
    AppButtonHeight.lg => const _ButtonDimensions(height: 56, loadingSize: 20),
  };

  TextStyle _textStyleFor(AppButtonHeight h, AppTypographyTheme t) => switch (h) {
    AppButtonHeight.sm => t.labelSmall,
    AppButtonHeight.md => t.labelMedium,
    AppButtonHeight.lg => t.labelLarge,
  };

  Widget _buildChild(
    Color contentColor,
    double loadingSize,
    TextStyle textStyle,
  ) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Processing...',
            style: textStyle.copyWith(
              color: contentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: loadingSize,
            height: loadingSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: contentColor,
            ),
          ),
        ],
      );
    }

    return DefaultTextStyle(
      style: textStyle.copyWith(
        color: contentColor,
        fontWeight: FontWeight.bold,
      ),
      child: IconTheme.merge(
        data: IconThemeData(color: contentColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Flexible(child: child),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      ),
    );
  }
}

class _ButtonDimensions {
  final double height;
  final double loadingSize;
  const _ButtonDimensions({required this.height, required this.loadingSize});
}

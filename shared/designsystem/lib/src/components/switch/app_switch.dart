import 'package:designsystem/src/components/switch/app_switch_colors.dart';
import 'package:designsystem/src/components/switch/app_switch_enums.dart';
import 'package:designsystem/src/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final AppSwitchSize size;
  final AppSwitchIntent intent;
  final String? label;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = AppSwitchSize.md,
    this.intent = AppSwitchIntent.primary,
    this.label,
  });

  static const double _disabledOpacity = 0.5;
  static const Duration _animationDuration = Duration(milliseconds: 200);
  static const Curve _animationCurve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final theme = context.switchTheme;
    final colors = theme.byIntent(intent);
    final dims = _dimensionsFor(size);
    final isDisabled = onChanged == null;

    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged!(!value),
      child: Opacity(
        opacity: isDisabled ? _disabledOpacity : 1.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTrack(colors, dims),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(label!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTrack(AppSwitchColors colors, _SwitchDimensions dims) {
    return AnimatedContainer(
      duration: _animationDuration,
      curve: _animationCurve,
      width: dims.trackWidth,
      height: dims.trackHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dims.trackHeight / 2),
        color: value ? colors.trackActive : colors.trackInactive,
      ),
      child: AnimatedAlign(
        duration: _animationDuration,
        curve: _animationCurve,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(dims.thumbPadding),
          child: Container(
            width: dims.thumbSize,
            height: dims.thumbSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.thumb,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _SwitchDimensions _dimensionsFor(AppSwitchSize s) => switch (s) {
    AppSwitchSize.sm => const _SwitchDimensions(
      trackWidth: 40,
      trackHeight: 22,
      thumbSize: 16,
      thumbPadding: 3,
    ),
    AppSwitchSize.md => const _SwitchDimensions(
      trackWidth: 52,
      trackHeight: 30,
      thumbSize: 22,
      thumbPadding: 4,
    ),
    AppSwitchSize.lg => const _SwitchDimensions(
      trackWidth: 64,
      trackHeight: 36,
      thumbSize: 28,
      thumbPadding: 4,
    ),
  };
}

class _SwitchDimensions {
  final double trackWidth;
  final double trackHeight;
  final double thumbSize;
  final double thumbPadding;

  const _SwitchDimensions({
    required this.trackWidth,
    required this.trackHeight,
    required this.thumbSize,
    required this.thumbPadding,
  });
}

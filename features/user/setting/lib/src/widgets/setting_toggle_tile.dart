import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';

/// A settings row whose trailing control is an [AppSwitch].
///
/// Stateless: it reflects the [value] handed to it and forwards changes
/// (from both the switch and a tap anywhere on the row) through [onChanged].
/// The owning widget holds the actual state, keeping rebuilds to this one row.
class SettingToggleTile extends StatelessWidget {
  /// The primary, already-localized row label.
  final String label;

  /// Optional secondary line shown beneath [label].
  final String? subtitle;

  /// Leading glyph rendered in the brand colour.
  final IconData icon;

  /// Current on/off state of the switch.
  final bool value;

  /// Invoked with the new value when toggled. A null value disables the row.
  final ValueChanged<bool>? onChanged;

  const SettingToggleTile({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    this.subtitle,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ListTile(
      leading: Icon(icon, color: colors.brand),
      title: AppText.bodyMedium(
        label,
        color: colors.contentPrimary,
        textWeight: AppTextWeight.medium,
      ),
      subtitle: subtitle != null
          ? AppText.captionSmall(
              subtitle!,
              color: colors.contentSecondary,
              textWeight: AppTextWeight.light,
            )
          : null,
      trailing: AppSwitch(
        value: value,
        onChanged: onChanged,
        size: AppSwitchSize.sm,
      ),
      // Tapping the row mirrors the switch for a larger, friendlier hit target.
      onTap: onChanged == null ? null : () => onChanged!(!value),
    );
  }
}

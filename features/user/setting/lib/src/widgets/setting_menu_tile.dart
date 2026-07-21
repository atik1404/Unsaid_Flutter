import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';

/// A single navigational settings row: leading icon, label, optional subtitle
/// and a trailing chevron.
///
/// Stateless and self-contained — it owns no business logic, only renders the
/// values it is given and reports taps through [onTap].
class SettingMenuTile extends StatelessWidget {
  /// The primary, already-localized row label.
  final String label;

  /// Optional secondary line shown beneath [label].
  final String? subtitle;

  /// Leading glyph rendered in the brand colour.
  final IconData icon;

  /// Invoked when the row is tapped. A null value renders a non-interactive row.
  final VoidCallback? onTap;

  const SettingMenuTile({
    super.key,
    required this.label,
    required this.icon,
    this.subtitle,
    this.onTap,
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
      trailing: Icon(Icons.chevron_right, color: colors.contentTertiary),
      onTap: onTap,
    );
  }
}

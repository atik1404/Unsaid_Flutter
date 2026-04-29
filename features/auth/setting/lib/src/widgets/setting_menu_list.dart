import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';

/// A vertical list of menu items on the Settings screen.
///
/// Each item has an icon, label, and trailing chevron (except Logout).
/// Tapping a row navigates to the corresponding screen or triggers
/// the logout confirmation dialog.
class SettingMenuList extends StatelessWidget {
  const SettingMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = _buildMenuItems(context);

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16.r),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.borderPrimary,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: menuItems.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: context.colorScheme.borderSubtle,
        ),
        itemBuilder: (context, index) => menuItems[index],
      ),
    );
  }

  /// Assembles the list of menu row widgets.
  List<Widget> _buildMenuItems(BuildContext context) {
    return [
      _SettingMenuItem(
        icon: Icons.person_outline,
        label: context.l10n.setting_menu_profile,
        onTap: () => context.pushNamed(AppRouteName.profileScreen),
      ),
      _SettingMenuItem(
        icon: Icons.lock_outline,
        label: context.l10n.setting_menu_change_password,
        onTap: () => context.pushNamed(AppRouteName.changePasswordScreen),
      ),
      _SettingMenuItem(
        icon: Icons.language,
        label: context.l10n.setting_menu_change_language,
        onTap: () {
          // TODO: Implement language picker
        },
      ),
      _SettingMenuItem(
        icon: Icons.logout,
        label: context.l10n.setting_menu_logout,
        isDestructive: true,
        onTap: () => _showLogoutConfirmation(context),
      ),
    ];
  }

  /// Shows a confirmation dialog before logging the user out.
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: AppText.titleSmall(
          context.l10n.setting_logout_confirm_title,
          textWeight: AppTextWeight.bold,
        ),
        content: AppText.bodySmall(
          context.l10n.setting_logout_confirm_message,
          color: context.colorScheme.contentSecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: AppText.bodySmall(
              context.l10n.setting_logout_confirm_no,
              textWeight: AppTextWeight.medium,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // TODO: Clear session and navigate to login
              context.goNamed(AppRouteName.loginScreen);
            },
            child: AppText.bodySmall(
              context.l10n.setting_logout_confirm_yes,
              color: context.colorScheme.contentError,
              textWeight: AppTextWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single row inside the settings menu list.
///
/// Displays an [icon], [label], and an optional trailing chevron.
/// When [isDestructive] is true, the icon and label are rendered
/// in the error colour to signal a destructive action (e.g. logout).
class _SettingMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? context.colorScheme.contentError
        : context.colorScheme.contentPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.s12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s16.w,
          vertical: AppSpacing.s16.h,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24.r),
            SizedBox(width: AppSpacing.s16.w),
            Expanded(
              child: AppText.bodySmall(
                label,
                color: color,
                textWeight: AppTextWeight.medium,
              ),
            ),
            if (!isDestructive)
              Icon(
                Icons.chevron_right,
                color: context.colorScheme.contentSecondary,
                size: 24.r,
              ),
          ],
        ),
      ),
    );
  }
}

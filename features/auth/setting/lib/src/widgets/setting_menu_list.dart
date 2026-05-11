import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A vertical list of menu items on the Settings screen.
///
/// Each item has an icon, label, and trailing chevron (except Logout).
/// Tapping a row navigates to the corresponding screen or triggers
/// the logout confirmation dialog.
class SettingMenuList extends StatelessWidget {
  const SettingMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context, title: 'IDENTITY', textColor: context.appColors.contentSecondary),
        SizedBox(height: AppSpacing.s4.h),
        _buildIdentityMenuCard(context),
        SizedBox(height: AppSpacing.s12.h),
        _buildTitle(context, title: 'PRIVACY', textColor: context.appColors.contentSecondary),
        SizedBox(height: AppSpacing.s4.h),
        _buildPrivacyMenuCard(context),

        SizedBox(height: AppSpacing.s12.h),
        _buildTitle(context, title: 'PRIVACY', textColor: context.appColors.contentSecondary),
        SizedBox(height: AppSpacing.s4.h),
        _buildPrivacyMenuCard(context),
        SizedBox(height: AppSpacing.s12.h),
        _buildTitle(context, title: 'DANZER ZONE', textColor: context.appColors.contentError),
        SizedBox(height: AppSpacing.s4.h),
        _buildDanzerZoneMenuCard(context),
      ],
    );
  }

  Widget _buildIdentityMenuCard(BuildContext context) {
    return AppCard.rounded(
      cornerRadius: AppCardCornerRadius.lg,
      child: Column(
        children: [
          _buildMenuItem(
            context,
            label: 'Regenarate alias',
            icon: Icons.refresh,
            onTap: () {
              // Handle tap
            },
          ),
          const AppDivider(),
          _buildMenuItem(
            context,
            label: 'Change avatar',
            icon: Icons.person,
            onTap: () {
              // Handle tap
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyMenuCard(BuildContext context) {
    return AppCard.rounded(
      cornerRadius: AppCardCornerRadius.lg,
      child: Column(
        children: [
          _buildToggleMenuItem(
            context,
            label: 'Regenarate alias',
            icon: Icons.refresh,
            value: true,
            onChanged: (value) {
              // Handle toggle change
            },
          ),
          const AppDivider(),
          _buildToggleMenuItem(
            context,
            label: 'Regenarate alias',
            icon: Icons.refresh,
            value: true,
            onChanged: (value) {
              // Handle toggle change
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDanzerZoneMenuCard(BuildContext context) {
    return AppCard.rounded(
      cornerRadius: AppCardCornerRadius.lg,
      tone: AppCardTone.danzer,
      child: Column(
        children: [
          _buildMenuItem(
            context,
            label: 'Regenarate alias',
            icon: Icons.refresh,
            onTap: () {
              // Handle tap
            },
          ),
          const AppDivider(),
          _buildMenuItem(
            context,
            label: 'Change avatar',
            icon: Icons.person,
            onTap: () {
              // Handle tap
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required String label, required IconData icon, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: context.appColors.brand),
      title: AppText.bodyMedium(label, color: context.appColors.contentPrimary, textWeight: AppTextWeight.medium),
      subtitle: AppText.captionSmall('Currently: ghost_8899', color: context.appColors.contentSecondary, textWeight: AppTextWeight.light),
      trailing: Icon(Icons.chevron_right, color: context.appColors.contentTertiary),
      onTap: onTap,
    );
  }

  Widget _buildToggleMenuItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool value,
    ValueChanged<bool>? onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: context.appColors.brand),
      title: AppText.bodyMedium(label, color: context.appColors.contentPrimary, textWeight: AppTextWeight.medium),
      subtitle: AppText.captionSmall('Currently: ghost_8899', color: context.appColors.contentSecondary, textWeight: AppTextWeight.light),
      trailing: AppSwitch(
        value: true,
        onChanged: onChanged,
        size: AppSwitchSize.sm,
      ),
      onTap: onChanged == null ? null : () => onChanged(!value),
    );
  }

  Widget _buildTitle(BuildContext context, {required String title, required Color textColor}) {
    return AppText.captionMedium(title, color: textColor, textWeight: AppTextWeight.light);
  }
}

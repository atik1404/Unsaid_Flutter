import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:setting/src/widgets/language_pill_toggle.dart';

/// A vertical list of menu items on the Settings screen.
///
/// Each item has an icon, label, and trailing chevron (except Logout).
/// Tapping a row navigates to the corresponding screen or triggers
/// the logout confirmation dialog.
class SettingMenuList extends StatefulWidget {
  const SettingMenuList({super.key});

  @override
  State<SettingMenuList> createState() => _SettingMenuListState();
}

class _SettingMenuListState extends State<SettingMenuList> {
  bool _allowAnonymousDMs = true;
  bool _ghostMode = true;
  bool _pushNotifications = true;
  bool _sound = true;

  @override
  Widget build(BuildContext context) {
    final gapLarge = SizedBox(height: AppSpacing.s12.h);
    final gapSmall = SizedBox(height: AppSpacing.s4.h);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(title: 'IDENTITY', textColor: context.appColors.contentSecondary),
        gapSmall,
        _buildIdentityMenuCard(context),
        gapLarge,
        _buildTitle(title: 'NOTIFICATION', textColor: context.appColors.contentSecondary),
        gapSmall,
        _buildNotificationMenuCard(context),

        gapLarge,
        _buildTitle(title: 'PRIVACY', textColor: context.appColors.contentSecondary),
        gapSmall,
        _buildPrivacyMenuCard(context),
        gapLarge,
        _buildTitle(title: 'DANZER ZONE', textColor: context.appColors.contentError),
        gapSmall,
        _buildDanzerZoneMenuCard(context),

        gapLarge,
        gapLarge,
        gapLarge,
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
            label: 'Profile',
            icon: CupertinoIcons.profile_circled,
            onTap: () {
              context.pushNamed(AppRouteName.profileScreen);
            },
          ),
          const AppDivider(),
          _buildMenuItem(
            context,
            label: 'Regenarate alias',
            subTitle: 'Currently: ghost_8899',
            icon: CupertinoIcons.refresh,
            onTap: () {
              AppLog.log('Regenerating alias...');
            },
          ),
          const AppDivider(),
          _buildMenuItem(
            context,
            label: 'Change avatar',
            subTitle: 'Ghost, skull, alien, robot',
            icon: CupertinoIcons.photo,
            onTap: () {
              AppLog.log('Changing avatar...');
            },
          ),
          const AppDivider(),
          _buildMenuItem(
            context,
            label: 'Change password',
            subTitle: '••••••••',
            icon: CupertinoIcons.lock,
            onTap: () {
              context.pushNamed(AppRouteName.changePasswordScreen);
            },
          ),
          const AppDivider(),
          _buildLanguageChangeMenu(),
          const AppDivider(),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return _buildToggleMenuItem(
                context,
                label: 'Dark mode',
                subTitle: 'Follow system theme',
                icon: CupertinoIcons.moon,
                value: themeMode == ThemeMode.dark,
                onChanged: (value) => context.read<ThemeCubit>().setDarkMode(value),
              );
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
            label: 'Allow anonymous DMs',
            subTitle: 'Strangers can message you.',
            icon: CupertinoIcons.chat_bubble,
            value: _allowAnonymousDMs,
            onChanged: (value) {
              setState(() => _allowAnonymousDMs = value);
              AppLog.log('Toggling anonymous DMs: $value');
            },
          ),
          const AppDivider(),
          _buildToggleMenuItem(
            context,
            label: 'Ghost mode',
            subTitle: 'Hide your online status.',
            icon: Icons.visibility_off,
            value: _ghostMode,
            onChanged: (value) {
              setState(() => _ghostMode = value);
              AppLog.log('Toggling ghost mode: $value');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationMenuCard(BuildContext context) {
    return AppCard.rounded(
      cornerRadius: AppCardCornerRadius.lg,
      child: Column(
        children: [
          _buildToggleMenuItem(
            context,
            label: 'Push notifications',
            icon: CupertinoIcons.bell,
            value: _pushNotifications,
            onChanged: (value) {
              setState(() => _pushNotifications = value);
              AppLog.log('Toggling push notifications: $value');
            },
          ),
          const AppDivider(),
          _buildToggleMenuItem(
            context,
            label: 'Sound',
            icon: CupertinoIcons.volume_up,
            value: _sound,
            onChanged: (value) {
              setState(() => _sound = value);
              AppLog.log('Toggling sound: $value');
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
            label: 'Wipe all my posts',
            subTitle: 'Permanently delete all your posts.',
            icon: CupertinoIcons.bin_xmark,
            onTap: () {
              AppLog.log('Wiping all posts...');
            },
          ),
          AppDivider(
            colorOverride: context.appColors.borderPrimary,
          ),
          _buildMenuItem(
            context,
            label: 'Delete ghost account',
            subTitle: 'Permanently delete ghost account.',
            icon: CupertinoIcons.trash,
            onTap: () {
              context.goNamed(AppRouteName.loginScreen);
            },
          ),
          AppDivider(
            colorOverride: context.appColors.borderPrimary,
          ),
          _buildMenuItem(
            context,
            label: 'Sign out',
            subTitle: 'Sign out of your account.',
            icon: CupertinoIcons.arrow_right_square,
            onTap: () {
              context.goNamed(AppRouteName.loginScreen);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required String label, String? subTitle, required IconData icon, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: context.appColors.brand),
      title: AppText.bodyMedium(label, color: context.appColors.contentPrimary, textWeight: AppTextWeight.medium),
      subtitle: subTitle != null ? AppText.captionSmall(subTitle, color: context.appColors.contentSecondary, textWeight: AppTextWeight.light) : null,
      trailing: Icon(Icons.chevron_right, color: context.appColors.contentTertiary),
      onTap: onTap,
    );
  }

  Widget _buildLanguageChangeMenu() {
    return BlocBuilder<LocalizationCubit, Locale>(
      builder: (context, locale) {
        return ListTile(
          leading: Icon(CupertinoIcons.globe, color: context.appColors.brand),
          title: AppText.bodyMedium('Language', color: context.appColors.contentPrimary, textWeight: AppTextWeight.medium),
          subtitle: AppText.captionSmall('Change app language', color: context.appColors.contentSecondary, textWeight: AppTextWeight.light),
          trailing: LanguagePillToggle(
            isEnglish: locale.languageCode == AppConstants.en,
            onToggle: (isEnglish) {
              final newLocale = isEnglish ? const Locale(AppConstants.en) : const Locale(AppConstants.bn);
              context.read<LocalizationCubit>().changeLocale(newLocale.languageCode);
            },
          ),
        );
      },
    );
  }

  Widget _buildToggleMenuItem(
    BuildContext context, {
    required String label,
    String? subTitle,
    required IconData icon,
    required bool value,
    ValueChanged<bool>? onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: context.appColors.brand),
      title: AppText.bodyMedium(label, color: context.appColors.contentPrimary, textWeight: AppTextWeight.medium),
      subtitle: subTitle != null ? AppText.captionSmall(subTitle, color: context.appColors.contentSecondary, textWeight: AppTextWeight.light) : null,
      trailing: AppSwitch(
        value: value,
        onChanged: onChanged,
        size: AppSwitchSize.sm,
      ),
      onTap: onChanged == null ? null : () => onChanged(!value),
    );
  }

  Widget _buildTitle({required String title, required Color textColor}) {
    return AppText.captionMedium(title, color: textColor, textWeight: AppTextWeight.light);
  }
}

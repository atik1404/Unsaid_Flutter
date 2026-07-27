import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:pref_storage/pref_storage.dart';
import 'package:setting/src/state/delete_all_posts_cubit.dart';
import 'package:setting/src/state/setting_cubit.dart';
import 'package:setting/src/state/setting_state.dart';
import 'package:setting/src/widgets/delete_all_posts_bottom_sheet.dart';
import 'package:setting/src/widgets/language_pill_toggle.dart';
import 'package:setting/src/widgets/setting_menu_tile.dart';
import 'package:setting/src/widgets/setting_section_label.dart';
import 'package:setting/src/widgets/setting_toggle_tile.dart';

/// The full menu shown on the Settings screen, grouped into four cards:
/// Identity, Notification, Privacy and a Danger Zone.
///
/// This is the "smart" container: it wires section cards to the [SettingCubit],
/// [ThemeCubit] and [LocalizationCubit] and handles navigation. Every row is a
/// const "dumb" tile ([SettingMenuTile] / [SettingToggleTile]), and each toggle
/// sits behind its own `BlocSelector`/`BlocBuilder` so flipping one switch
/// rebuilds only that row — never the whole list.
class SettingMenuList extends StatelessWidget {
  const SettingMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final gapLarge = SizedBox(height: AppSpacing.s12.h);
    final gapSmall = SizedBox(height: AppSpacing.s4.h);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingSectionLabel(
          title: context.l10n.setting_section_identity,
          color: colors.contentSecondary,
        ),
        gapSmall,
        const _IdentitySection(),
        gapLarge,
        SettingSectionLabel(
          title: context.l10n.setting_section_notification,
          color: colors.contentSecondary,
        ),
        gapSmall,
        const _NotificationSection(),
        gapLarge,
        //SettingSectionLabel(title: context.l10n.setting_section_privacy, color: colors.contentSecondary),
        //gapSmall,
        //const _PrivacySection(),
        // gapLarge,
        SettingSectionLabel(
          title: context.l10n.setting_section_danger_zone,
          color: colors.contentError,
        ),
        gapSmall,
        const _DangerZoneSection(),
        SizedBox(height: AppSpacing.s32.h),
      ],
    );
  }
}

/// Identity card: profile, alias, avatar, password, language and dark mode.
class _IdentitySection extends StatelessWidget {
  const _IdentitySection();

  @override
  Widget build(BuildContext context) {
    return AppCard.rounded(
      cornerRadius: AppCardCornerRadius.lg,
      child: Column(
        children: [
          SettingMenuTile(
            label: context.l10n.setting_menu_profile,
            icon: CupertinoIcons.profile_circled,
            onTap: () => context.pushNamed(AppRouteName.profileScreen),
          ),
          const AppDivider(),
          SettingMenuTile(
            label: context.l10n.setting_menu_regenerate_alias,
            subtitle: context.l10n.setting_menu_alias_current('Echo'),
            icon: CupertinoIcons.refresh,
            onTap: () => AppLog.log('Regenerating alias...'),
          ),
          const AppDivider(),
          SettingMenuTile(
            label: context.l10n.setting_menu_change_avatar,
            subtitle: context.l10n.setting_menu_change_avatar_subtitle,
            icon: CupertinoIcons.photo,
            onTap: () => AppLog.log('Changing avatar...'),
          ),
          const AppDivider(),
          SettingMenuTile(
            label: context.l10n.setting_menu_change_password,
            subtitle: context.l10n.setting_menu_change_password_subtitle,
            icon: CupertinoIcons.lock,
            onTap: () => context.pushNamed(AppRouteName.changePasswordScreen),
          ),
          const AppDivider(),
          const _LanguageRow(),
          const AppDivider(),
          // Rebuilds only when the app theme mode changes.
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return SettingToggleTile(
                label: context.l10n.setting_menu_dark_mode,
                subtitle: context.l10n.setting_menu_dark_mode_subtitle,
                icon: CupertinoIcons.moon,
                value: themeMode == ThemeMode.dark,
                onChanged: (value) =>
                    context.read<ThemeCubit>().setDarkMode(value),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Language row: rebuilds only when the active locale changes.
class _LanguageRow extends StatelessWidget {
  const _LanguageRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, Locale>(
      builder: (context, locale) {
        return ListTile(
          leading: Icon(CupertinoIcons.globe, color: context.appColors.brand),
          title: AppText.bodyMedium(
            context.l10n.setting_menu_language,
            color: context.appColors.contentPrimary,
            textWeight: AppTextWeight.medium,
          ),
          subtitle: AppText.captionSmall(
            context.l10n.setting_menu_language_subtitle,
            color: context.appColors.contentSecondary,
            textWeight: AppTextWeight.light,
          ),
          trailing: LanguagePillToggle(
            isEnglish: locale.languageCode == AppConstants.en,
            onToggle: (isEnglish) {
              final code = isEnglish ? AppConstants.en : AppConstants.bn;
              context.read<LocalizationCubit>().changeLocale(code);
            },
          ),
        );
      },
    );
  }
}

/// Notification card: push notifications and sound toggles.
class _NotificationSection extends StatelessWidget {
  const _NotificationSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingCubit>();
    return AppCard.rounded(
      cornerRadius: AppCardCornerRadius.lg,
      child: Column(
        children: [
          // Rebuilds only when the push-notifications flag changes.
          BlocBuilder<SettingCubit, SettingState>(
            //selector: (state) => state.pushNotifications,
            builder: (context, state) {
              return SettingToggleTile(
                label: context.l10n.setting_menu_push_notifications,
                icon: CupertinoIcons.bell,
                value: state.pushNotifications,
                onChanged: (value) {
                  cubit.setPushNotifications(value: value);
                },
              );
            },
          ),
          const AppDivider(),
          // Rebuilds only when the sound flag changes.
          BlocBuilder<SettingCubit, SettingState>(
            //selector: (state) => state.soundEnabled,
            builder: (context, state) {
              return SettingToggleTile(
                label: context.l10n.setting_menu_sound,
                icon: CupertinoIcons.volume_up,
                value: state.soundEnabled,
                onChanged: (value) {
                  cubit.setSoundEnabled(value: value);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Privacy card: anonymous DMs and ghost mode toggles.
// ignore: unused_element
class _PrivacySection extends StatelessWidget {
  const _PrivacySection();

  @override
  Widget build(BuildContext context) {
    return AppCard.rounded(
      cornerRadius: AppCardCornerRadius.lg,
      child: Column(
        children: [
          // Rebuilds only when the anonymous-DMs flag changes.
          BlocSelector<SettingCubit, SettingState, bool>(
            selector: (state) => state.allowAnonymousDms,
            builder: (context, enabled) {
              return SettingToggleTile(
                label: context.l10n.setting_menu_allow_anonymous_dms,
                subtitle:
                    context.l10n.setting_menu_allow_anonymous_dms_subtitle,
                icon: CupertinoIcons.chat_bubble,
                value: enabled,
                onChanged: (value) {},
              );
            },
          ),
          const AppDivider(),
          // Rebuilds only when the ghost-mode flag changes.
          BlocSelector<SettingCubit, SettingState, bool>(
            selector: (state) => state.ghostMode,
            builder: (context, enabled) {
              return SettingToggleTile(
                label: context.l10n.setting_menu_ghost_mode,
                subtitle: context.l10n.setting_menu_ghost_mode_subtitle,
                icon: Icons.visibility_off,
                value: enabled,
                onChanged: (value) {},
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Danger zone card: destructive actions (wipe posts, delete account, sign out).
class _DangerZoneSection extends StatelessWidget {
  const _DangerZoneSection();

  @override
  Widget build(BuildContext context) {
    final divider = AppDivider(colorOverride: context.appColors.borderPrimary);
    return AppCard.rounded(
      cornerRadius: AppCardCornerRadius.lg,
      tone: AppCardTone.danzer,
      child: Column(
        children: [
          SettingMenuTile(
            label: context.l10n.setting_menu_wipe_posts,
            subtitle: context.l10n.setting_menu_wipe_posts_subtitle,
            icon: CupertinoIcons.bin_xmark,
            onTap: () => showDeleteAllPostsBottomSheet(context),
          ),
          divider,
          SettingMenuTile(
            label: context.l10n.setting_menu_delete_account,
            subtitle: context.l10n.setting_menu_delete_account_subtitle,
            icon: CupertinoIcons.trash,
            onTap: () => context.pushNamed(AppRouteName.deleteAccountScreen),
          ),
          divider,
          SettingMenuTile(
            label: context.l10n.setting_menu_sign_out,
            subtitle: context.l10n.setting_menu_sign_out_subtitle,
            icon: CupertinoIcons.arrow_right_square,
            onTap: () => _onSignOut(context),
          ),
        ],
      ),
    );
  }

  /// Clears persisted data, flips the router's auth guard and sends the user to
  /// a clean home/login location.
  Future<void> _onSignOut(BuildContext context) async {
    // Record the logout against the outgoing analytics session and detach the
    // user id, so the anonymous activity that follows isn't attributed to the
    // account that just signed out.
    await GetIt.I<AnalyticsTracker>().endSession(reason: 'user_initiated');

    await GetIt.I<AppPrefStorage>().clear();
    // Flips the router's auth guard; an explicit go (not a redirect) lands the
    // user on a clean location without a leftover redirect param.
    authStateNotifier.setLoggedIn(isLoggedIn: false);
    if (context.mounted) context.goNamed(AppRouteName.homeScreen);
  }
}

/// Opens the delete-all-posts confirmation bottom sheet.
///
/// The sheet owns its own [DeleteAllPostsCubit], scoped to the modal route, so
/// the destructive flow is fully self-contained and torn down on dismissal.
Future<void> showDeleteAllPostsBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) => DeleteAllPostsCubit(
        deleteAllPostsUseCase: GetIt.I<DeleteAllPostsUseCase>(),
      ),
      child: const DeleteAllPostsBottomSheet(),
    ),
  );
}

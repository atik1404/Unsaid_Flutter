import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:setting/src/state/setting_cubit.dart';
import 'package:setting/src/state/setting_state.dart';
import 'package:setting/src/widgets/profile_summary_card.dart';
import 'package:setting/src/widgets/setting_menu_list.dart';

/// The main Settings screen (the "smart" widget).
///
/// Lays out the static page chrome — top bar and scroll view — and delegates
/// presentation to two children: a profile summary card and the menu list.
/// Only the profile card is wrapped in a `BlocSelector`, so loading the user's
/// data rebuilds that card alone while the const [SettingMenuList] stays put.
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppTopBar(
        titleWidget: AppText.headlineSmall(
          context.l10n.setting_title,
          textWeight: AppTextWeight.extraBold,
          color: context.appColors.contentBrand,
        ),
        backgroundColor: context.scaffoldTheme.backgroundColor,
        foregroundColor: context.appColors.brand,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16.w, vertical: AppSpacing.s16.h),
        child: Column(
          children: [
            // Rebuilds only when the profile fields change (i.e. once loaded).
            BlocSelector<SettingCubit, SettingState, ({String name, String subtitle, String avatarUrl})>(
              selector: (state) => (name: state.fullname, subtitle: state.phone, avatarUrl: state.avatarUrl),
              builder: (context, profile) {
                return ProfileSummaryCard(
                  name: profile.name,
                  subtitle: profile.subtitle,
                  avatarUrl: profile.avatarUrl,
                );
              },
            ),
            SizedBox(height: AppSpacing.s24.h),

            // Navigation + toggle menu. Const so it never rebuilds with the card.
            const SettingMenuList(),
          ],
        ),
      ),
    );
  }
}

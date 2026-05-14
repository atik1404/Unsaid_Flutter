import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:setting/src/state/setting_cubit.dart';
import 'package:setting/src/state/setting_state.dart';
import 'package:setting/src/widgets/profile_summary_card.dart';
import 'package:setting/src/widgets/setting_menu_list.dart';

/// The main Settings screen.
///
/// Displays a profile summary card at the top followed by a menu list
/// of actions (Profile, Change Password, Change Language, Logout).
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingCubit>().loadUserProfile();
  }

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
      body: BlocBuilder<SettingCubit, SettingState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16.w, vertical: AppSpacing.s16.h),
            child: Column(
              children: [
                // User profile summary at the top
                ProfileSummaryCard(
                  name: state.userName,
                  email: state.userEmail,
                  avatarUrl: state.avatarUrl,
                ),
                SizedBox(height: AppSpacing.s24.h),

                // Navigation menu items
                const SettingMenuList(),
              ],
            ),
          );
        },
      ),
    );
  }
}

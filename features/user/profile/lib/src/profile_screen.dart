import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:profile/src/state/profile_cubit.dart';
import 'package:profile/src/state/profile_state.dart';
import 'package:profile/src/widgets/profile_header.dart';
import 'package:profile/src/widgets/profile_post_list.dart';
import 'package:ui/ui.dart';

/// The Profile screen.
///
/// Shows the user's personal information at the top (via [ProfileHeader])
/// and their own posts below (via [ProfilePostList]).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return AppScaffold(
          appBar: AppTopBar(
            backgroundColor: context.scaffoldTheme.backgroundColor,
            titleWidget: AppText.headlineSmall(
              context.l10n.profile_title,
              textWeight: AppTextWeight.extraBold,
              color: context.appColors.contentBrand,
            ),
            foregroundColor: context.appColors.brand,
            elevation: 0,
            actions: [
              AppTextButton('Edit', onPressed: () {}),
            ],
          ),
          isLoading: state.isLoading,
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    if (state.isLoading) {
      return const SizedBox.shrink();
    }

    if (state.profile == null) {
      return const AppErrorScreen();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.s16.r),
      child: Column(
        children: [
          // Personal information
          ProfileHeader(
            profile: state.profile!,
          ),
          SizedBox(height: AppSpacing.s24.h),

          if (state.isPostLoading) ...[
            const Center(
              child: CircularProgressIndicator(),
            ),
          ] else ...[
            // Own posts section
            ProfilePostList(posts: state.posts),
          ],
        ],
      ),
    );
  }
}

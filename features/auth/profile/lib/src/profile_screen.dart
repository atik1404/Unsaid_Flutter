import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:profile/src/state/profile_cubit.dart';
import 'package:profile/src/state/profile_state.dart';
import 'package:profile/src/widgets/profile_header.dart';
import 'package:profile/src/widgets/profile_post_list.dart';

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
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppTopBar(
        titleWidget: AppText.titleMedium(
          context.l10n.profile_title,
          textWeight: AppTextWeight.extraBold,
        ),
        elevation: 0,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.s16.r),
            child: Column(
              children: [
                // Personal information
                ProfileHeader(
                  name: state.name,
                  email: state.email,
                  phone: state.phone,
                  bio: state.bio,
                  avatarUrl: state.avatarUrl,
                ),
                SizedBox(height: AppSpacing.s24.h),

                // Own posts section
                ProfilePostList(posts: state.posts),
              ],
            ),
          );
        },
      ),
    );
  }
}

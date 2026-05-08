import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A compact card that displays the user's avatar, name, and email.
///
/// Shown at the top of the Settings screen to give the user a quick
/// snapshot of their identity.
class ProfileSummaryCard extends StatelessWidget {
  /// The user's display name.
  final String name;

  /// The user's email address.
  final String email;

  /// URL for the user's avatar image.
  /// Falls back to a default icon when empty.
  final String avatarUrl;

  const ProfileSummaryCard({
    super.key,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.s16.r),
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16.r),
        boxShadow: [
          BoxShadow(
            color: context.appColors.borderPrimary,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar circle
          _buildAvatar(context),
          SizedBox(width: AppSpacing.s16.w),

          // Name and email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.titleSmall(
                  name,
                  textWeight: AppTextWeight.bold,
                ),
                SizedBox(height: AppSpacing.s4.h),
                AppText.bodySmall(
                  email,
                  color: context.appColors.contentSecondary,
                  textWeight: AppTextWeight.medium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a circular avatar.
  ///
  /// Uses a default person icon when [avatarUrl] is empty.
  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 32.r,
      backgroundColor: context.appColors.backgroundPrimary,
      child: avatarUrl.isEmpty
          ? Icon(
              Icons.person,
              size: 32.r,
              color: context.appColors.contentBrand,
            )
          : null,
    );
  }
}

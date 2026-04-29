import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';

/// Displays the profile owner's personal information.
///
/// Renders a large avatar circle followed by name, email, phone,
/// and bio in a styled card container.
class ProfileHeader extends StatelessWidget {
  /// The user's display name.
  final String name;

  /// The user's email address.
  final String email;

  /// The user's phone number.
  final String phone;

  /// A short bio / tagline.
  final String bio;

  /// URL for the user's avatar image.
  final String avatarUrl;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.s24.r),
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
      child: Column(
        children: [
          // Avatar
          _buildAvatar(context),
          SizedBox(height: AppSpacing.s16.h),

          // Name
          AppText.titleMedium(
            name,
            textWeight: AppTextWeight.bold,
          ),
          SizedBox(height: AppSpacing.s4.h),

          // Bio
          AppText.bodySmall(
            bio,
            color: context.colorScheme.contentSecondary,
            textWeight: AppTextWeight.medium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.s16.h),

          // Info rows
          _buildInfoRow(
            context,
            icon: Icons.email_outlined,
            label: context.l10n.profile_label_email,
            value: email,
          ),
          SizedBox(height: AppSpacing.s8.h),
          _buildInfoRow(
            context,
            icon: Icons.phone_outlined,
            label: context.l10n.profile_label_phone,
            value: phone,
          ),
        ],
      ),
    );
  }

  /// Builds a large circular avatar with a default icon fallback.
  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 48.r,
      backgroundColor: context.colorScheme.backgroundBadge,
      child: avatarUrl.isEmpty
          ? Icon(
              Icons.person,
              size: 48.r,
              color: context.colorScheme.contentBrand,
            )
          : null,
    );
  }

  /// Renders a single information row with an icon, label, and value.
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.r,
          color: context.colorScheme.contentSecondary,
        ),
        SizedBox(width: AppSpacing.s8.w),
        AppText.captionSmall(
          '$label: ',
          color: context.colorScheme.contentSecondary,
          textWeight: AppTextWeight.medium,
        ),
        Expanded(
          child: AppText.bodySmall(
            value,
            textWeight: AppTextWeight.medium,
          ),
        ),
      ],
    );
  }
}

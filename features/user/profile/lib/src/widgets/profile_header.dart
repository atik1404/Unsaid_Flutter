import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
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
      padding: EdgeInsets.all(AppSpacing.s12.r),
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
      child: Column(
        children: [
          // Avatar
          _buildAvatar(context),
          SizedBox(height: AppSpacing.s16.h),

          // Name
          AppText.titleMedium(
            name,
            color: context.appColors.contentBrand,
            textWeight: AppTextWeight.bold,
          ),
          SizedBox(height: AppSpacing.s4.h),

          // Bio
          AppText.captionMedium(
            bio,
            color: context.appColors.contentSecondary,
            textWeight: AppTextWeight.medium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.s16.h),

          _buildRegenerateAvatar(context),
          SizedBox(height: AppSpacing.s24.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //spacing: AppSpacing.s8.w,
            children: [
              _InfoBox(
                label: context.l10n.profile_stat_post,
                value: "256",
                color: context.appColors.contentBrand,
              ),

              _InfoBox(
                label: context.l10n.profile_stat_reaction,
                value: "2.5K",
                color: context.appColors.contentInfo,
              ),

              _InfoBox(
                label: context.l10n.profile_stat_days,
                value: "365",
                color: context.appColors.contentWarning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a large circular avatar with a default icon fallback.
  Widget _buildAvatar(BuildContext context) {
    return AppImage.network(
      'https://thumbs.dreamstime.com/b/futuristic-alien-portrait-sci-fi-environment-high-detail-grey-skinned-humanoid-figure-elongated-smooth-head-large-379960286.jpg?w=576',
      width: IconSizes.avatar,
      height: IconSizes.avatar,
      shape: ImageShape.circle,
      fit: BoxFit.cover,
      borderColor: context.appColors.borderPrimary,
      borderWidth: 1,
      padding: EdgeInsets.all(AppSpacing.s2.r),
    );
  }

  Widget _buildRegenerateAvatar(BuildContext context) {
    return AppTag(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8.w, vertical: AppSpacing.s2.h),
      leading: AppIcon(Icon(CupertinoIcons.refresh, color: context.modeColors.neutral.textColor)),
      backgroundColor: context.modeColors.neutral.backgroundColor,
      child: AppText.bodySmall(
        context.l10n.profile_action_regenerate_avatar,
        color: context.modeColors.neutral.textColor,
      ),
    );
  }
}

final class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.rounded(
      elevation: 2,
      tone: AppCardTone.secondary,
      variant: AppCardVariant.outline,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s24.w, vertical: AppSpacing.s8.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.headlineMedium(
            value,
            color: color,
            textWeight: AppTextWeight.medium,
          ),
          SizedBox(height: AppSpacing.s8.h),
          AppText.captionSmall(
            label,
            color: context.appColors.contentSecondary,
            textWeight: AppTextWeight.medium,
          ),
        ],
      ),
    );
  }
}

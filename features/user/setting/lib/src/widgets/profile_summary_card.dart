import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A compact card that displays the user's avatar, name and a secondary line.
///
/// Shown at the top of the Settings screen to give the user a quick snapshot of
/// their identity. Purely presentational — every value is supplied by the
/// parent, so the card holds no state and never fetches anything itself.
class ProfileSummaryCard extends StatelessWidget {
  /// The user's display name.
  final String name;

  /// Secondary line beneath the name (e.g. phone number or email).
  final String subtitle;

  /// URL for the user's avatar image. Falls back to a default icon when empty
  /// or when the image fails to load.
  final String avatarUrl;

  const ProfileSummaryCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.rounded(
      padding: EdgeInsets.all(AppSpacing.s16.r),
      variant: AppCardVariant.outline,
      cornerRadius: AppCardCornerRadius.lg,
      child: Row(
        children: [
          _buildAvatar(context),
          SizedBox(width: AppSpacing.s16.w),

          // Name and secondary line.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.titleSmall(
                  name,
                  textWeight: AppTextWeight.bold,
                  color: context.appColors.contentBrand,
                ),
                SizedBox(height: AppSpacing.s4.h),
                AppText.bodySmall(
                  subtitle,
                  color: context.appColors.contentSecondary,
                  textWeight: AppTextWeight.light,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a circular avatar from [avatarUrl], showing a person icon when the
  /// URL is empty or the network image cannot be loaded.
  Widget _buildAvatar(BuildContext context) {
    if (avatarUrl.isEmpty) return _avatarFallback(context);

    return AppImage.network(
      avatarUrl,
      width: IconSizes.prominent,
      height: IconSizes.prominent,
      shape: ImageShape.circle,
      fit: BoxFit.cover,
      borderColor: context.appColors.borderBrand,
      borderWidth: 1,
      padding: EdgeInsets.all(AppSpacing.s2.r),
      errorBuilder: (_, _, _) => _avatarFallback(context),
    );
  }

  /// Default avatar shown when no image is available.
  Widget _avatarFallback(BuildContext context) {
    return Container(
      width: IconSizes.prominent,
      height: IconSizes.prominent,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.appColors.surfaceSecondary,
        border: Border.all(color: context.appColors.borderBrand),
      ),
      child: Icon(
        CupertinoIcons.person_fill,
        color: context.appColors.contentTertiary,
      ),
    );
  }
}

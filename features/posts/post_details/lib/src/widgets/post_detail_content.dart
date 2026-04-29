import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders the full description body of a post.
///
/// Presented in a styled card below the [PostDetailHeader].
class PostDetailContent extends StatelessWidget {
  /// The full post description text.
  final String description;

  const PostDetailContent({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.s16.r),
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
      child: AppText.bodySmall(
        description,
        color: context.colorScheme.contentPrimary,
        textWeight: AppTextWeight.medium,
      ),
    );
  }
}

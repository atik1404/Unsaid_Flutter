import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A single-selection ("radio") row used to pick a deletion reason.
///
/// Dumb by design: it renders the [label] and a leading radio indicator driven
/// by [selected], and reports taps upward via [onTap]. Selection state is owned
/// by the cubit.
class DeleteReasonTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const DeleteReasonTile({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16.w, vertical: AppSpacing.s12.h),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? colors.brand : colors.contentTertiary,
              size: AppSpacing.s24.r,
            ),
            SizedBox(width: AppSpacing.s12.w),
            Expanded(
              child: AppText.bodyMedium(
                label,
                color: selected ? colors.contentPrimary : colors.contentSecondary,
                textWeight: selected ? AppTextWeight.semiBold : AppTextWeight.regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

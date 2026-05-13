import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notification/src/state/notification_state.dart';

class NotificationFilterTab extends StatelessWidget {
  final NotificationFilter selected;
  final int unreadCount;
  final ValueChanged<NotificationFilter> onFilterChanged;

  const NotificationFilterTab({
    super.key,
    required this.selected,
    required this.unreadCount,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s16.w,
        vertical: AppSpacing.s12.h,
      ),
      child: Row(
        children: [
          _FilterPill(
            label: 'All',
            isSelected: selected == NotificationFilter.all,
            onTap: () => onFilterChanged(NotificationFilter.all),
          ),
          SizedBox(width: AppSpacing.s8.w),
          _FilterPill(
            label: unreadCount > 0 ? 'Unread ($unreadCount)' : 'Unread',
            isSelected: selected == NotificationFilter.unread,
            onTap: () => onFilterChanged(NotificationFilter.unread),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s16.w,
          vertical: AppSpacing.s8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.contentBrand : colors.surfaceSecondary,
          borderRadius: BorderRadius.circular(AppRadius.rFull.r),
          border: Border.all(
            color: isSelected ? colors.contentBrand : colors.borderPrimary,
          ),
        ),
        child: AppText.captionSmall(
          label,
          color: isSelected ? colors.white : colors.contentSecondary,
          textWeight:
              isSelected ? AppTextWeight.semiBold : AppTextWeight.regular,
        ),
      ),
    );
  }
}

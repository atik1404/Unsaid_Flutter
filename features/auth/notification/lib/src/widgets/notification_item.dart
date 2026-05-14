import 'package:designsystem/designsystem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notification/src/state/notification_model.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isUnread = !notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s16.w,
          vertical: AppSpacing.s12.h,
        ),
        decoration: BoxDecoration(
          color: isUnread ? colors.surfaceSecondary : colors.backgroundPrimary,
          border: Border(
            bottom: BorderSide(color: colors.borderInner),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NotificationAvatar(notification: notification),
            SizedBox(width: AppSpacing.s12.w),
            Expanded(
              child: _NotificationContent(notification: notification),
            ),
            SizedBox(width: AppSpacing.s8.w),
            _NotificationMeta(notification: notification),
          ],
        ),
      ),
    );
  }
}

class _NotificationAvatar extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationAvatar({required this.notification});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _resolveColors(notification.type, context);

    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(
        child: notification.senderName != null
            ? AppText.bodySmall(
                notification.senderName![0].toUpperCase(),
                color: fg,
                textWeight: AppTextWeight.bold,
              )
            : Icon(_resolveIcon(notification.type), color: fg, size: 20.r),
      ),
    );
  }

  (Color, Color) _resolveColors(NotificationType type, BuildContext context) {
    final c = context.appColors;
    return switch (type) {
      NotificationType.like => (c.surfaceDestructive, c.contentInfo),
      NotificationType.comment => (c.surfaceAvatar, c.contentBrand),
      NotificationType.follow => (c.surfaceTertiary, c.contentSuccess),
      NotificationType.mention => (c.surfaceTertiary, c.contentWarning),
      NotificationType.system => (c.surfaceSecondary, c.contentSubtle),
    };
  }

  IconData _resolveIcon(NotificationType type) {
    return switch (type) {
      NotificationType.like => CupertinoIcons.heart_fill,
      NotificationType.comment => CupertinoIcons.chat_bubble_fill,
      NotificationType.follow => CupertinoIcons.person_fill,
      NotificationType.mention => CupertinoIcons.at,
      NotificationType.system => CupertinoIcons.bell_fill,
    };
  }
}

class _NotificationContent extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationContent({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodySmall(
          notification.title,
          textWeight: notification.isRead ? AppTextWeight.regular : AppTextWeight.semiBold,
          color: context.appColors.contentPrimary,
        ),
        SizedBox(height: AppSpacing.s2.h),
        AppText.captionSmall(
          notification.message,
          color: context.appColors.contentSecondary,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _NotificationMeta extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationMeta({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppText.captionSmall(
          Jiffy.parseFromDateTime(notification.createdAt).fromNow(),
          color: context.appColors.contentSubtle,
        ),
        if (!notification.isRead) ...[
          SizedBox(height: AppSpacing.s4.h),
          Container(
            width: AppRadius.r8.r,
            height: 8.r,
            decoration: BoxDecoration(
              color: context.appColors.contentBrand,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}

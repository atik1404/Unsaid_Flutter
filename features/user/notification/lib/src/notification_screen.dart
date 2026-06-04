import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';
import 'package:notification/src/state/notification_cubit.dart';
import 'package:notification/src/state/notification_state.dart';
import 'package:notification/src/widgets/notification_filter_tab.dart';
import 'package:notification/src/widgets/notification_item.dart';
import 'package:ui/ui.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppTopBar(
        titleWidget: AppText.headlineSmall(
          context.l10n.notification_title,
          textWeight: AppTextWeight.extraBold,
        ),
        backgroundColor: context.scaffoldTheme.backgroundColor,
        foregroundColor: context.appColors.brand,
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            buildWhen: (prev, curr) => prev.unreadCount != curr.unreadCount,
            builder: (context, state) {
              if (state.unreadCount == 0) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(right: AppSpacing.s8.w),
                child: AppTextButton(
                  context.l10n.notification_action_mark_all_read,
                  onPressed: context.read<NotificationCubit>().markAllAsRead,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<NotificationCubit, NotificationState>(
            buildWhen: (prev, curr) => prev.filter != curr.filter || prev.unreadCount != curr.unreadCount,
            builder: (context, state) {
              return NotificationFilterTab(
                selected: state.filter,
                unreadCount: state.unreadCount,
                onFilterChanged: context.read<NotificationCubit>().setFilter,
              );
            },
          ),
          Expanded(
            child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: context.appColors.contentBrand,
                    ),
                  );
                }

                final items = state.visibleNotifications;

                if (items.isEmpty) {
                  return AppErrorScreen(title: context.l10n.notification_empty_title, message: context.l10n.notification_empty_message);
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final notification = items[index];
                    return NotificationItem(
                      notification: notification,
                      onTap: () {
                        context.read<NotificationCubit>().markAsRead(notification.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

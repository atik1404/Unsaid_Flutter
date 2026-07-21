import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification/src/state/notification_model.dart';
import 'package:notification/src/state/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState());

  void loadNotifications() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();
    final notifications = [
      NotificationModel(
        id: '1',
        type: NotificationType.like,
        title: 'Alex liked your post',
        message: '"Had the most amazing day exploring the city..."',
        createdAt: now.subtract(const Duration(minutes: 2)),
        senderName: 'Alex Morgan',
      ),
      NotificationModel(
        id: '2',
        type: NotificationType.comment,
        title: 'Sarah commented on your post',
        message: '"This is such a beautiful perspective! 💜"',
        createdAt: now.subtract(const Duration(minutes: 18)),
        senderName: 'Sarah Kim',
      ),
      NotificationModel(
        id: '3',
        type: NotificationType.follow,
        title: 'Mike started following you',
        message: 'You have a new follower.',
        createdAt: now.subtract(const Duration(hours: 1)),
        senderName: 'Mike Torres',
      ),
      NotificationModel(
        id: '4',
        type: NotificationType.mention,
        title: 'You were mentioned in a post',
        message: '"Check out what @you said about this topic..."',
        createdAt: now.subtract(const Duration(hours: 3)),
        senderName: 'Jordan Lee',
      ),
      NotificationModel(
        id: '5',
        type: NotificationType.system,
        title: 'Dark mode is now available',
        message: 'Update the app to try the new dark theme experience.',
        createdAt: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: '6',
        type: NotificationType.like,
        title: 'Emma liked your comment',
        message: '"Totally agree with everything you said here!"',
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: true,
        senderName: 'Emma Walsh',
      ),
      NotificationModel(
        id: '7',
        type: NotificationType.comment,
        title: 'Jordan replied to your comment',
        message: '"I had the exact same thought! Great minds think alike."',
        createdAt: now.subtract(const Duration(days: 3)),
        isRead: true,
        senderName: 'Jordan Lee',
      ),
      NotificationModel(
        id: '8',
        type: NotificationType.follow,
        title: 'Chris started following you',
        message: 'You have a new follower.',
        createdAt: now.subtract(const Duration(days: 5)),
        isRead: true,
        senderName: 'Chris Park',
      ),
    ];

    emit(state.copyWith(isLoading: false, notifications: notifications));
  }

  void markAsRead(String id) {
    final updated = state.notifications
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();
    emit(state.copyWith(notifications: updated));
  }

  void markAllAsRead() {
    final updated = state.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    emit(state.copyWith(notifications: updated));
  }

  void setFilter(NotificationFilter filter) {
    emit(state.copyWith(filter: filter));
  }
}

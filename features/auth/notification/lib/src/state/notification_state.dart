import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notification/src/state/notification_model.dart';

part 'notification_state.freezed.dart';

@freezed
abstract class NotificationState with _$NotificationState {

  const factory NotificationState({
    @Default([]) List<NotificationModel> notifications,
    @Default(false) bool isLoading,
    @Default(NotificationFilter.all) NotificationFilter filter,
    String? errorMessage,
  }) = _NotificationState;
  const NotificationState._();

  List<NotificationModel> get visibleNotifications => filter == NotificationFilter.unread ? notifications.where((n) => !n.isRead).toList() : notifications;

  int get unreadCount => notifications.where((n) => !n.isRead).length;
}

enum NotificationFilter { all, unread }

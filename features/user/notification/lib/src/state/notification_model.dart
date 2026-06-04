import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required NotificationType type,
    required String title,
    required String message,
    required DateTime createdAt,
    @Default(false) bool isRead,
    String? senderName,
  }) = _NotificationModel;
}

enum NotificationType { like, comment, follow, mention, system }

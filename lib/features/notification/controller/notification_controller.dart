import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_clone_apps/apis/notification_api.dart';
import 'package:twitter_clone_apps/core/enums/notification_type_enum.dart';
import 'package:twitter_clone_apps/models/notification_model.dart';

part 'notification_controller.g.dart';

@riverpod
Future<List<Notification>> getNotifications(GetNotificationsRef ref) {
  final notificationController = ref.read(notificationControllerProvider.notifier);

  return notificationController.getNotifications();
}

@riverpod
Stream<RealtimeMessage> streamLatestNotification(StreamLatestNotificationRef ref) {
  final tweetApi = ref.read(notificationApiProvider);

  return tweetApi.streamLatestNotification();
}

@riverpod
class NotificationController extends _$NotificationController {
  late NotificationAPI _notificationAPI;

  @override
  void build() {
    _notificationAPI = ref.watch(notificationApiProvider);
  }

  Future<List<Notification>> getNotifications() async {
    final result = await _notificationAPI.getNotifications();

    return result.fold(
      (failure) => [],
      (notifications) => notifications,
    );
  }

  Future<void> createNotification({
    required String uid,
    required String text,
    required NotificationType notificationType,
    String postId = '',
  }) async {
    final notification = Notification(
      uid: uid,
      text: text,
      notificationType: notificationType,
      postId: postId,
      isRead: false,
    );

    await _notificationAPI.createNotification(notification: notification);
  }

  Future<void> markAllAsRead() async {
    await _notificationAPI.markAllAsRead();
  }

  Future<void> markAsRead({required String notificationId}) async {
    await _notificationAPI.markAsRead(notificationId: notificationId);
  }
}

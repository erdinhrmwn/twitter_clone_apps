import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/core/constants/appwrite_constants.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/notification/controller/notification_controller.dart';
import 'package:twitter_clone_apps/features/notification/widgets/notification_tile.dart';
import 'package:twitter_clone_apps/models/notification_model.dart' as model;

class NotificationView extends HookConsumerWidget {
  const NotificationView({super.key});

  static route() => MaterialPageRoute(builder: (context) => const NotificationView());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const databaseId = AppwriteConstants.databaseId;
    const collectionId = AppwriteConstants.notificationsCollectionId;

    final currentUser = ref.watch(currentUserProvider).value;
    final notifications = ref.watch(getNotificationsProvider);
    final streamLatestNotification = ref.watch(streamLatestNotificationProvider);
    final notificationController = ref.read(notificationControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            onPressed: () async {
              await notificationController.markAllAsRead();
            },
            icon: const Icon(FontAwesomeIcons.checkDouble),
          ),
        ],
      ),
      body: notifications.when(
        data: (notifications) {
          return streamLatestNotification.when(
            data: (data) {
              if (data.events.contains('databases.$databaseId.collections.$collectionId.documents.*.create')) {
                final notification = model.Notification.fromJson(data.payload);
                if (notification.uid == currentUser?.$id) {
                  notifications.insert(0, notification);
                }
              }

              if (data.events.contains('databases.$databaseId.collections.$collectionId.documents.*.update')) {
                final updatedData = model.Notification.fromJson(data.payload);
                final index = notifications.indexWhere((t) => t.id == updatedData.id);
                if (index != -1) {
                  notifications[index] = updatedData;
                }
              }

              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];

                  return NotificationTile(notification: notification);
                },
              );
            },
            loading: () => ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return NotificationTile(notification: notification);
              },
            ),
            error: (error, stackTrace) => Center(child: Text(error.toString())),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
    );
  }
}

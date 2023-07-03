import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/core/enums/notification_type_enum.dart';
import 'package:twitter_clone_apps/core/helpers/format_helper.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';
import 'package:twitter_clone_apps/features/notification/controller/notification_controller.dart';

import 'package:twitter_clone_apps/models/notification_model.dart' as model;

class NotificationTile extends HookConsumerWidget {
  const NotificationTile({super.key, required this.notification});

  final model.Notification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationController = ref.read(notificationControllerProvider.notifier);

    return ListTile(
      leading: notification.notificationType == NotificationType.like
          ? const Icon(
              FontAwesomeIcons.solidHeart,
              color: Palette.redColor,
              size: 20,
            )
          : notification.notificationType == NotificationType.follow
              ? const Icon(
                  FontAwesomeIcons.person,
                  color: Palette.blueColor,
                  size: 20,
                )
              : notification.notificationType == NotificationType.retweet
                  ? const Icon(
                      FontAwesomeIcons.retweet,
                      color: Palette.greenColor,
                      size: 20,
                    )
                  : null,
      minLeadingWidth: 0,
      title: Row(
        children: [
          Text(
            notification.text,
            style: AppTextStyles.body.bold,
          ),
          const Spacer(),
          Text(
            FormatHelper.formatDiffForHumans(notification.createdAt),
            style: AppTextStyles.body,
          ),
        ],
      ),
      trailing: notification.isRead ? null : const Icon(Icons.brightness_1, color: Colors.blue, size: 10),
      onTap: () async {
        await notificationController.markAsRead(notificationId: notification.id);
      },
    );
  }
}

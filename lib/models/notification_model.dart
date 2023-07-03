import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twitter_clone_apps/core/enums/notification_type_enum.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class Notification with _$Notification {
  const factory Notification({
    @Default('') @JsonKey(name: "\$id", includeToJson: false) String id,
    required String uid,
    required String text,
    @Default('') String postId,
    @NotificationTypeConverter() required NotificationType notificationType,
    @Default(false) bool isRead,
    @JsonKey(name: "\$createdAt", includeToJson: false) DateTime? createdAt,
    @JsonKey(name: "\$updatedAt", includeToJson: false) DateTime? updatedAt,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
}

class NotificationTypeConverter implements JsonConverter<NotificationType, String> {
  const NotificationTypeConverter();

  @override
  NotificationType fromJson(String json) {
    return json.toNotificationTypeEnum();
  }

  @override
  String toJson(NotificationType object) {
    return object.type;
  }
}

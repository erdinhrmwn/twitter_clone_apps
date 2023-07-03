import 'package:appwrite/appwrite.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_clone_apps/core/constants/appwrite_constants.dart';
import 'package:twitter_clone_apps/core/providers/appwrite_provider.dart';
import 'package:twitter_clone_apps/core/types/types.dart';
import 'package:twitter_clone_apps/models/notification_model.dart';

part 'notification_api.g.dart';

@riverpod
NotificationAPI notificationApi(NotificationApiRef ref) {
  final database = ref.read(appwriteDbProvider);
  final account = ref.read(appwriteAccountProvider);
  final realtime = ref.read(appwriteRealtimeProvider);

  return NotificationAPI(databases: database, account: account, realtime: realtime);
}

class NotificationAPI implements INotificationAPI {
  final String databaseId = AppwriteConstants.databaseId;
  final String collectionId = AppwriteConstants.notificationsCollectionId;

  late final Account _account;
  late final Databases _database;
  late final Realtime _realtime;

  NotificationAPI({
    required Databases databases,
    required Account account,
    required Realtime realtime,
  })  : _database = databases,
        _account = account,
        _realtime = realtime;

  @override
  FutureEither<List<Notification>> getNotifications() async {
    try {
      final user = await _account.get();
      final response = await _database.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.equal('uid', user.$id),
          Query.orderDesc('\$createdAt'),
        ],
      );

      final notifications = response.documents.map((doc) => Notification.fromJson(doc.data)).toList();

      return right(notifications);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid createNotification({required Notification notification}) async {
    try {
      await _database.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: notification.toJson(),
      );

      return right(null);
    } on AppwriteException catch (error, stackTrace) {
      print(error);
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      print(error);
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid markAllAsRead() async {
    try {
      final user = await _account.get();
      final response = await _database.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.equal('uid', user.$id),
          Query.equal('isRead', false),
        ],
      );

      final unreadNotifications = response.documents.map((e) => Notification.fromJson(e.data)).toList();

      await Future.wait(unreadNotifications.map((e) => markAsRead(notificationId: e.id)));

      return right(null);
    } on AppwriteException catch (error, stackTrace) {
      print(error);
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      print(error);
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid markAsRead({required String notificationId}) async {
    try {
      await _database.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: notificationId,
        data: {'isRead': true},
      );

      return right(null);
    } on AppwriteException catch (error, stackTrace) {
      print(error);
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      print(error);
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid deleteAllNotifications() async {
    try {
      final user = await _account.get();
      final response = await _database.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.equal('uid', user.$id),
        ],
      );

      final notifications = response.documents.map((e) => Notification.fromJson(e.data)).toList();

      await Future.wait(notifications.map((e) => deleteNotification(notificationId: e.id)));

      return right(null);
    } on AppwriteException catch (error, stackTrace) {
      print(error);
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      print(error);
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid deleteNotification({required String notificationId}) async {
    try {
      await _database.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: notificationId,
      );

      return right(null);
    } on AppwriteException catch (error, stackTrace) {
      print(error);
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      print(error);
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  Stream<RealtimeMessage> streamLatestNotification() {
    return _realtime.subscribe([
      'databases.$databaseId.collections.$collectionId.documents',
    ]).stream;
  }
}

abstract class INotificationAPI {
  FutureEither<List<Notification>> getNotifications();
  FutureEitherVoid createNotification({required Notification notification});
  FutureEitherVoid markAllAsRead();
  FutureEitherVoid markAsRead({required String notificationId});
  FutureEitherVoid deleteNotification({required String notificationId});
  FutureEitherVoid deleteAllNotifications();
  Stream<RealtimeMessage> streamLatestNotification();
}

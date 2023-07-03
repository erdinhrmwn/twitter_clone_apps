import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_clone_apps/core/constants/appwrite_constants.dart';
import 'package:twitter_clone_apps/core/providers/appwrite_provider.dart';
import 'package:twitter_clone_apps/core/types/types.dart';
import 'package:twitter_clone_apps/models/user_model.dart';

part 'user_api.g.dart';

@riverpod
UserAPI userApi(UserApiRef ref) {
  final database = ref.read(appwriteDbProvider);
  final realtime = ref.read(appwriteRealtimeProvider);

  return UserAPI(database: database, realtime: realtime);
}

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel user);
  Future<Document> getUserData(String userId);
  Future<DocumentList> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatestUserProfileData();
  FutureEitherVoid handleFollowers(UserModel user);
  FutureEitherVoid handleFollowing(UserModel user);
}

class UserAPI implements IUserAPI {
  final String databaseId = AppwriteConstants.databaseId;
  final String collectionId = AppwriteConstants.usersCollectionId;

  final Databases _database;
  final Realtime _realtime;

  UserAPI({required Databases database, required Realtime realtime})
      : _database = database,
        _realtime = realtime;

  @override
  FutureEitherVoid saveUserData(UserModel user) async {
    try {
      await _database.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: user.uid,
        data: user.toJson(),
      );

      return right(null);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  Future<Document> getUserData(String uid) async {
    try {
      final response = await _database.getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: uid,
      );

      return response;
    } on AppwriteException catch (error, stackTrace) {
      throw Failure(error.message.toString(), stackTrace);
    } catch (error, stackTrace) {
      throw Failure(error.toString(), stackTrace);
    }
  }

  @override
  Future<DocumentList> searchUserByName(String name) {
    try {
      return _database.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.search('name', name),
        ],
      );
    } on AppwriteException catch (error, stackTrace) {
      throw Failure(error.message.toString(), stackTrace);
    } catch (error, stackTrace) {
      throw Failure(error.toString(), stackTrace);
    }
  }

  @override
  FutureEitherVoid handleFollowers(UserModel user) async {
    try {
      await _database.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: user.uid,
        data: {
          'followers': user.followers,
        },
      );

      return right(null);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid handleFollowing(UserModel user) async {
    try {
      await _database.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: user.uid,
        data: {
          'following': user.following,
        },
      );

      return right(null);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realtime.subscribe([
      'databases.$databaseId.collections.$collectionId.documents',
    ]).stream;
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      await _database.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: userModel.uid,
        data: {
          'name': userModel.name,
          'bio': userModel.bio,
          'profilePic': userModel.profilePic,
          'coverPic': userModel.coverPic,
          'isTwitterBlue': userModel.isTwitterBlue,
        },
      );

      return right(null);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }
}

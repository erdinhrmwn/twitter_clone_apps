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

  return UserAPI(database: database);
}

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel user);
  Future<Document> getUserData(String userId);
}

class UserAPI implements IUserAPI {
  final String databaseId = AppwriteConstants.databaseId;
  final String collectionId = AppwriteConstants.usersCollectionId;

  final Databases _database;

  UserAPI({required Databases database}) : _database = database;

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
}

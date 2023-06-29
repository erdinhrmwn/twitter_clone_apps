// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:twitter_clone_apps/core/constants/appwrite_constants.dart';
import 'package:twitter_clone_apps/core/providers/appwrite_provider.dart';
import 'package:twitter_clone_apps/core/types/types.dart';
import 'package:twitter_clone_apps/models/tweet_model.dart';

part 'tweet_api.g.dart';

@riverpod
TweetAPI tweetApi(TweetApiRef ref) {
  final database = ref.read(appwriteDbProvider);
  final realtime = ref.read(appwriteRealtimeProvider);

  return TweetAPI(database: database, realtime: realtime);
}

class TweetAPI implements ITweetAPI {
  final String databaseId = AppwriteConstants.databaseId;
  final String collectionId = AppwriteConstants.tweetsCollectionId;

  final Databases _database;
  final Realtime _realtime;

  TweetAPI({
    required Databases database,
    required Realtime realtime,
  })  : _database = database,
        _realtime = realtime;

  @override
  FutureEither<Document> createTweet({required Tweet tweet}) async {
    try {
      final result = await _database.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: tweet.toJson(),
      );

      return right(result);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  FutureEither<List<Tweet>> getTweets() async {
    try {
      final response = await _database.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );

      final tweets = response.documents.map((e) => Tweet.fromJson(e.data)).toList();

      return right(tweets);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.$databaseId.collections.$collectionId.documents',
    ]).stream;
  }
}

abstract class ITweetAPI {
  FutureEither<Document> createTweet({required Tweet tweet});
  FutureEither<List<Tweet>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
}

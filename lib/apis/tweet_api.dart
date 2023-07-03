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
        queries: [
          Query.equal('repliedTo', ''),
          Query.orderDesc('tweetedAt'),
        ],
      );

      final tweets = response.documents.map((e) => Tweet.fromJson(e.data)).toList();

      return right(tweets);
    } on AppwriteException catch (error, stackTrace) {
      print(error);
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      print(error);
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  Future<Tweet> getTweetById({required String tweetId}) async {
    final result = await _database.getDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: tweetId,
    );

    return Tweet.fromJson(result.data);
  }

  @override
  FutureEither<List<Tweet>> getReplyTweets({required String tweetId}) async {
    try {
      final response = await _database.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.equal('repliedTo', tweetId),
          Query.orderDesc('tweetedAt'),
        ],
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
  FutureEither<List<Tweet>> getTweetsByHashtag({required String hashtag}) async {
    try {
      final response = await _database.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.search('hashtags', hashtag),
          Query.orderDesc('tweetedAt'),
        ],
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
  Stream<RealtimeMessage> streamLatestTweet() {
    return _realtime.subscribe([
      'databases.$databaseId.collections.$collectionId.documents',
    ]).stream;
  }

  @override
  FutureEither<Document> likeTweet({required Tweet tweet}) async {
    try {
      final result = await _database.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: tweet.id,
        data: {
          'likes': tweet.likes,
        },
      );

      return right(result);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  FutureEither<Document> updateShareCount({required Tweet tweet}) async {
    try {
      final result = await _database.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: tweet.id,
        data: {
          'shareCount': tweet.shareCount,
        },
      );

      return right(result);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }

  @override
  FutureEither<List<Tweet>> getTweetsByUserId({required String uid}) async {
    try {
      final response = await _database.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.equal('uid', uid),
          Query.orderDesc('tweetedAt'),
        ],
      );

      final tweets = response.documents.map((e) => Tweet.fromJson(e.data)).toList();

      return right(tweets);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }
}

abstract class ITweetAPI {
  FutureEither<Document> createTweet({required Tweet tweet});
  FutureEither<List<Tweet>> getTweets();
  Future<Tweet> getTweetById({required String tweetId});
  FutureEither<List<Tweet>> getTweetsByUserId({required String uid});
  FutureEither<List<Tweet>> getReplyTweets({required String tweetId});
  FutureEither<List<Tweet>> getTweetsByHashtag({required String hashtag});
  FutureEither<Document> likeTweet({required Tweet tweet});
  FutureEither<Document> updateShareCount({required Tweet tweet});
  Stream<RealtimeMessage> streamLatestTweet();
}

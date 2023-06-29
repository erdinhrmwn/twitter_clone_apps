import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_clone_apps/apis/storage_api.dart';
import 'package:twitter_clone_apps/apis/tweet_api.dart';
import 'package:twitter_clone_apps/core/enums/tweet_type.dart';
import 'package:twitter_clone_apps/core/types/types.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/tweet/helpers/tweet_helpers.dart';
import 'package:twitter_clone_apps/models/tweet_model.dart';
import 'package:twitter_clone_apps/models/user_model.dart';

part 'tweet_controller.g.dart';

@riverpod
Future<List<Tweet>> getTweets(GetTweetsRef ref) {
  final tweetController = ref.read(tweetControllerProvider.notifier);

  return tweetController.getTweets();
}

@riverpod
Future<Tweet> getTweetById(GetTweetByIdRef ref, String tweetId) {
  final tweetController = ref.read(tweetControllerProvider.notifier);

  return tweetController.getTweetById(tweetId: tweetId);
}

@riverpod
Future<List<Tweet>> getReplyTweets(GetReplyTweetsRef ref, String tweetId) {
  final tweetController = ref.read(tweetControllerProvider.notifier);

  return tweetController.getReplyTweets(tweetId: tweetId);
}

@riverpod
Stream<RealtimeMessage> getLatestTweets(GetLatestTweetsRef ref) {
  final tweetApi = ref.read(tweetApiProvider);

  return tweetApi.getLatestTweet();
}

@riverpod
class TweetController extends _$TweetController {
  late TweetAPI _tweetApi;
  late StorageAPI _storageApi;
  late UserModel _currentUser;

  @override
  Future<void> build() async {
    _tweetApi = ref.read(tweetApiProvider);
    _storageApi = ref.read(storageApiProvider);
    _currentUser = ref.watch(currentUserDetailProvider).value!;
  }

  Future<List<Tweet>> getTweets() async {
    final result = await _tweetApi.getTweets();

    return result.fold(
      (failure) => [],
      (tweets) => tweets,
    );
  }

  Future<Tweet> getTweetById({required String tweetId}) async {
    final result = await _tweetApi.getTweetById(tweetId: tweetId);

    return result;
  }

  Future<List<Tweet>> getReplyTweets({required String tweetId}) async {
    final result = await _tweetApi.getReplyTweets(tweetId: tweetId);

    return result.fold(
      (failure) => [],
      (tweets) => tweets,
    );
  }

  FutureEither<Document> createTweet({
    String text = '',
    List<XFile> images = const [],
    String repliedTo = '',
  }) async {
    if (text.isEmpty && images.isEmpty) {
      return FutureEither.error('Tweet cannot be empty');
    }

    if (text.length > 280) {
      return FutureEither.error('Tweet cannot be more than 280 characters');
    }

    Tweet tweet = Tweet(
      text: '',
      uid: _currentUser.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      repliedTo: repliedTo,
    );

    if (text.isNotEmpty) {
      final hashtags = TweetHelpers.getHashtagsFromText(text);
      final link = TweetHelpers.getLinkFromText(text);

      tweet = tweet.copyWith(
        text: text,
        hashtags: hashtags,
        link: link,
      );
    }

    if (images.isNotEmpty) {
      final imageLinks = await _storageApi.uploadImages(images);

      tweet = tweet.copyWith(
        tweetType: TweetType.image,
        imageLinks: imageLinks,
      );
    }

    final result = await _tweetApi.createTweet(tweet: tweet);

    return result;
  }

  void likeTweet({required Tweet tweet}) async {
    List<String> likes = tweet.likes.toList();

    if (likes.contains(_currentUser.uid)) {
      likes.remove(_currentUser.uid);
    } else {
      likes.add(_currentUser.uid);
    }

    final updatedTweet = tweet.copyWith(likes: likes);
    await _tweetApi.likeTweet(tweet: updatedTweet);
  }

  void retweet({required Tweet tweet}) async {
    Tweet copiedTweet = tweet.copyWith(
      retweetedBy: _currentUser.uid,
      likes: [],
      commentIds: [],
      shareCount: tweet.shareCount + 1,
      tweetedAt: DateTime.now(),
    );

    final result = await _tweetApi.updateShareCount(tweet: copiedTweet);
    result.fold(
      (failure) => Future.error(failure),
      (tweet) async {
        final res = await _tweetApi.createTweet(
          tweet: copiedTweet.copyWith(
            id: ID.unique(),
            shareCount: 0,
          ),
        );

        res.fold(
          (failure) => Future.error(failure),
          (tweet) => Future.value(tweet.data),
        );
      },
    );
  }
}

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twitter_clone_apps/apis/storage_api.dart';
import 'package:twitter_clone_apps/apis/tweet_api.dart';
import 'package:twitter_clone_apps/core/enums/notification_type_enum.dart';
import 'package:twitter_clone_apps/core/enums/tweet_type.dart';
import 'package:twitter_clone_apps/core/types/types.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/notification/controller/notification_controller.dart';
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
Future<List<Tweet>> getUserTweets(GetUserTweetsRef ref, String uid) {
  final tweetController = ref.read(tweetControllerProvider.notifier);

  return tweetController.getUserTweets(uid: uid);
}

@riverpod
Future<List<Tweet>> getTweetsByHashtag(GetTweetsByHashtagRef ref, String hashtag) {
  final tweetController = ref.read(tweetControllerProvider.notifier);

  return tweetController.getTweetsByHashtag(hashtag: hashtag);
}

@riverpod
Stream<RealtimeMessage> streamLatestTweet(StreamLatestTweetRef ref) {
  final tweetApi = ref.read(tweetApiProvider);

  return tweetApi.streamLatestTweet();
}

@riverpod
class TweetController extends _$TweetController {
  late TweetAPI _tweetApi;
  late StorageAPI _storageApi;
  late UserModel _currentUser;
  late NotificationController _notificationController;

  @override
  Future<void> build() async {
    _tweetApi = ref.read(tweetApiProvider);
    _storageApi = ref.read(storageApiProvider);
    _currentUser = ref.watch(currentUserDetailProvider).value!;
    _notificationController = ref.read(notificationControllerProvider.notifier);
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

  Future<List<Tweet>> getTweetsByHashtag({required String hashtag}) async {
    final result = await _tweetApi.getTweetsByHashtag(hashtag: hashtag);

    return result.fold(
      (failure) => [],
      (tweets) => tweets,
    );
  }

  Future<List<Tweet>> getUserTweets({required String uid}) async {
    final result = await _tweetApi.getTweetsByUserId(uid: uid);

    return result.fold(
      (failure) => [],
      (tweets) => tweets,
    );
  }

  FutureEither<Document> createTweet({
    String text = '',
    List<XFile> images = const [],
    String repliedTo = '',
    String repliedToUser = '',
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
      final imageLinks = await _storageApi.uploadTweetImages(images);

      tweet = tweet.copyWith(
        tweetType: TweetType.image,
        imageLinks: imageLinks,
      );
    }

    final result = await _tweetApi.createTweet(tweet: tweet);

    if (result.isRight()) {
      if (repliedTo.isNotEmpty && tweet.uid != _currentUser.uid) {
        await _notificationController.createNotification(
          uid: repliedToUser,
          text: '${_currentUser.name} replied to your tweet',
          notificationType: NotificationType.reply,
          postId: repliedTo,
        );
      }
    }

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
    final result = await _tweetApi.likeTweet(tweet: updatedTweet);

    result.fold(
      (failure) => Future.error(failure),
      (tweet) async {
        if (updatedTweet.likes.contains(_currentUser.uid) && updatedTweet.uid != _currentUser.uid) {
          await _notificationController.createNotification(
            uid: updatedTweet.uid,
            text: '${_currentUser.name} liked your tweet',
            notificationType: NotificationType.like,
            postId: updatedTweet.id,
          );
        }
      },
    );
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
            shareCount: 1,
          ),
        );

        res.fold(
          (failure) => Future.error(failure),
          (tweet) async {
            if (copiedTweet.uid != _currentUser.uid) {
              await _notificationController.createNotification(
                uid: copiedTweet.uid,
                text: '${_currentUser.name} shared your tweet',
                notificationType: NotificationType.retweet,
                postId: copiedTweet.id,
              );
            }
          },
        );
      },
    );
  }
}

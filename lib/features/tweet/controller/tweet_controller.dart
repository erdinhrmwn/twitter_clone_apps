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

  FutureEither<Document> createTweet({
    String text = '',
    List<XFile> images = const [],
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
}

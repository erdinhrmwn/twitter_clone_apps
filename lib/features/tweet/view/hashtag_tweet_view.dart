import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/common/common.dart';
import 'package:twitter_clone_apps/core/constants/appwrite_constants.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';
import 'package:twitter_clone_apps/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone_apps/features/tweet/view/reply_tweet_view.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone_apps/models/tweet_model.dart';

class HashtagTweetView extends HookConsumerWidget {
  const HashtagTweetView({super.key, required this.hashtag});

  final String hashtag;

  static route({required String hashtag}) => MaterialPageRoute(builder: (context) => HashtagTweetView(hashtag: hashtag));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const databaseId = AppwriteConstants.databaseId;
    const collectionId = AppwriteConstants.tweetsCollectionId;

    final tweetsProvider = ref.watch(getTweetsByHashtagProvider(hashtag));
    final streamLatestTweet = ref.watch(streamLatestTweetProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(hashtag, style: AppTextStyles.h4.bold),
        centerTitle: true,
      ),
      body: tweetsProvider.when(
        data: (tweets) => streamLatestTweet.when(
          skipLoadingOnReload: true,
          data: (data) {
            if (data.events.contains('databases.$databaseId.collections.$collectionId.documents.*.update')) {
              final updatedData = Tweet.fromJson(data.payload);
              final index = tweets.indexWhere((t) => t.id == updatedData.id);
              if (index != -1) {
                tweets[index] = updatedData;
              }
            }

            return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (context, index) {
                final tweet = tweets[index];
                return InkWell(
                  onTap: () => Navigator.of(context).push(ReplyTweetScreen.route(tweet)),
                  child: TweetCard(tweet: tweet),
                );
              },
            );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => ListView.builder(
            itemCount: tweets.length,
            itemBuilder: (context, index) {
              final tweet = tweets[index];

              return InkWell(
                onTap: () => Navigator.of(context).push(ReplyTweetScreen.route(tweet)),
                child: TweetCard(tweet: tweet),
              );
            },
          ),
        ),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const AppLoader(),
      ),
    );
  }
}

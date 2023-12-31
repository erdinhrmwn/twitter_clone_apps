import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/common/app_loader.dart';
import 'package:twitter_clone_apps/core/constants/appwrite_constants.dart';
import 'package:twitter_clone_apps/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone_apps/features/tweet/view/reply_tweet_view.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone_apps/models/tweet_model.dart';

class TweetList extends HookConsumerWidget {
  const TweetList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const databaseId = AppwriteConstants.databaseId;
    const collectionId = AppwriteConstants.tweetsCollectionId;

    final tweetsProvider = ref.watch(getTweetsProvider);
    final streamLatestTweet = ref.watch(streamLatestTweetProvider);

    return RefreshIndicator.adaptive(
      onRefresh: () async => {
        ref.refresh(getTweetsProvider.future),
        ref.refresh(streamLatestTweetProvider.future),
      },
      child: tweetsProvider.when(
        data: (tweets) => streamLatestTweet.when(
          data: (data) {
            final tweet = Tweet.fromJson(data.payload);
            if (data.events.contains('databases.$databaseId.collections.$collectionId.documents.*.create')) {
              if (tweet.repliedTo.isEmpty && !tweets.map((e) => e.id).contains(tweet.id)) {
                tweets.insert(0, tweet);
              }
            }

            if (data.events.contains('databases.$databaseId.collections.$collectionId.documents.*.update')) {
              final index = tweets.indexWhere((t) => t.id == tweet.id);
              if (index != -1) {
                tweets[index] = tweet;
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

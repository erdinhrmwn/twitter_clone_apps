import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/common/app_loader.dart';
import 'package:twitter_clone_apps/core/constants/appwrite_constants.dart';
import 'package:twitter_clone_apps/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone_apps/models/tweet_model.dart';

class TweetList extends HookConsumerWidget {
  const TweetList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweets = useState(<Tweet>[]);
    final isLoading = useState(true);

    const databaseId = AppwriteConstants.databaseId;
    const collectionId = AppwriteConstants.tweetsCollectionId;

    final tweetsProvider = ref.watch(getTweetsProvider.future);
    final streamLatestTweet = ref.watch(getLatestTweetsProvider);

    useEffect(() {
      tweetsProvider.then((value) {
        tweets.value = value.reversed.toList();
        isLoading.value = false;
      });

      return null;
    }, []);

    return isLoading.value
        ? const AppLoader()
        : tweets.value.isEmpty
            ? const Center(child: Text('No Tweets'))
            : streamLatestTweet.when(
                data: (data) {
                  if (data.events.contains('databases.$databaseId.collections.$collectionId.documents.*.create')) {
                    tweets.value.insert(0, Tweet.fromJson(data.payload));
                  }

                  return ListView.builder(
                    itemCount: tweets.value.length,
                    itemBuilder: (context, index) {
                      return TweetCard(tweet: tweets.value[index]);
                    },
                  );
                },
                error: (error, stackTrace) => Center(child: Text(error.toString())),
                loading: () => ListView.builder(
                  itemCount: tweets.value.length,
                  itemBuilder: (context, index) {
                    return TweetCard(tweet: tweets.value[index]);
                  },
                ),
              );
  }
}

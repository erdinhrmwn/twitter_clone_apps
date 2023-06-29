import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/common/common.dart';
import 'package:twitter_clone_apps/core/providers/media_manager_provider.dart';
import 'package:twitter_clone_apps/core/utils/snackbar.dart';
import 'package:twitter_clone_apps/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/reply_tweet_list.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone_apps/models/tweet_model.dart';

class ReplyTweetScreen extends HookConsumerWidget {
  const ReplyTweetScreen({
    super.key,
    required this.tweet,
  });

  final Tweet tweet;

  static route(Tweet tweet) => MaterialPageRoute(builder: (context) => ReplyTweetScreen(tweet: tweet));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweetController = ref.read(tweetControllerProvider.notifier);
    final mediaManager = ref.watch(mediaManagerProvider);

    final textController = useTextEditingController();

    final submitReply = useCallback(() async {
      final result = await tweetController.createTweet(text: textController.text, images: mediaManager, repliedTo: tweet.id);

      textController.clear();
      mediaManager.clear();

      result.fold(
        (failure) => showSnackbar(context, failure.message),
        (tweet) {
          // Navigator.of(context).pop(tweet);
        },
      );
    }, [textController.text, mediaManager]);

    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          Expanded(child: ReplyTweetList(tweetId: tweet.id)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: TextField(
          controller: textController,
          onSubmitted: (value) {
            submitReply();
          },
          decoration: InputDecoration(
            hintText: 'Tweet your reply',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                submitReply();
              },
            ),
          ),
        ),
      ),
    );
  }
}

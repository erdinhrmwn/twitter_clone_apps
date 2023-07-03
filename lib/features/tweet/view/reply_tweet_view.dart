import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone_apps/common/common.dart';
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
    final tweetImages = useState<List<XFile>>([]);
    final isLoading = useState(false);

    final textController = useTextEditingController();

    final submitReply = useCallback(() async {
      isLoading.value = true;

      final result = await tweetController.createTweet(
        text: textController.text,
        images: tweetImages.value,
        repliedTo: tweet.id,
        repliedToUser: tweet.uid,
      );

      textController.clear();
      tweetImages.value.clear();

      result.fold(
        (failure) => showSnackbar(context, failure.message),
        (tweet) {
          // Navigator.of(context).pop(tweet);
        },
      );
    }, [textController.text, tweetImages.value, isLoading.value]);

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
            if (!isLoading.value) submitReply();
          },
          decoration: InputDecoration(
            hintText: 'Tweet your reply',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (!isLoading.value) submitReply();
              },
            ),
          ),
        ),
      ),
    );
  }
}

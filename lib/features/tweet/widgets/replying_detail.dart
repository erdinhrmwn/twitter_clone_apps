import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/tweet/controller/tweet_controller.dart';

class ReplyingDetail extends HookConsumerWidget {
  const ReplyingDetail({super.key, required this.tweetId});

  final String tweetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: ref.watch(getTweetByIdProvider(tweetId)).when(
            data: (tweet) {
              return ref.watch(userDetailProvider(tweet.uid)).when(
                    data: (user) => RichText(
                      text: TextSpan(
                        text: "Replying to",
                        style: AppTextStyles.bodySm.grey,
                        children: [
                          TextSpan(
                            text: " @${user.uid}",
                            style: AppTextStyles.bodySm.bold.primary,
                          ),
                        ],
                      ),
                    ),
                    loading: () => const SizedBox(),
                    error: (e, s) => const SizedBox(),
                  );
            },
            loading: () => const SizedBox(),
            error: (e, s) => const SizedBox(),
          ),
    );
  }
}

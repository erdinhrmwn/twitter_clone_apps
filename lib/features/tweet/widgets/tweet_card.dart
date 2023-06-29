import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone_apps/common/app_loader.dart';
import 'package:twitter_clone_apps/common/simple_dot.dart';
import 'package:twitter_clone_apps/core/enums/tweet_type.dart';
import 'package:twitter_clone_apps/core/helpers/format_helper.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/replying_detail.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/retweet_detail.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/user_avatar.dart';
import 'package:twitter_clone_apps/models/tweet_model.dart';

class TweetCard extends HookConsumerWidget {
  const TweetCard({super.key, required this.tweet});

  final Tweet tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweetController = ref.read(tweetControllerProvider.notifier);
    final currentUser = ref.watch(currentUserDetailProvider).value;
    final userDetail = ref.watch(userDetailProvider(tweet.uid));

    final isLiked = useState(false);
    final isRetweeted = useState(false);

    useEffect(() {
      if (currentUser != null) {
        isLiked.value = tweet.likes.contains(currentUser.uid);
        isRetweeted.value = tweet.retweetedBy.contains(currentUser.uid);
      }

      return null;
    }, [tweet]);

    return currentUser == null
        ? const SizedBox(height: 100, child: AppLoader())
        : userDetail.when(
            data: (user) => Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Palette.greyColor.withOpacity(.3),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserAvatar(profilePic: user.profilePic),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (tweet.retweetedBy.isNotEmpty) RetweetDetail(uid: tweet.retweetedBy),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    user.name,
                                    style: AppTextStyles.body.bold.ellipsis,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    " @${user.uid}",
                                    style: AppTextStyles.body.grey.ellipsis,
                                  ),
                                ),
                                const SimpleDot(),
                                Text(
                                  FormatHelper.formatDiffForHumans(tweet.tweetedAt),
                                  style: AppTextStyles.body.grey,
                                ),
                              ],
                            ),
                            if (tweet.repliedTo.isNotEmpty) ReplyingDetail(tweetId: tweet.repliedTo),
                            const SizedBox(height: 4),
                            HashtagText(text: tweet.text),
                            if (tweet.tweetType == TweetType.image) CarouselImage(imageLinks: tweet.imageLinks),
                            if (tweet.link.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              AnyLinkPreview(link: "https://${tweet.link}", displayDirection: UIDirection.uiDirectionHorizontal),
                            ],
                            Container(
                              margin: const EdgeInsets.only(top: 8, right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TweetIconButton(icon: FontAwesomeIcons.chartSimple, text: (tweet.likes.length + tweet.commentIds.length + tweet.shareCount), onTap: () {}),
                                  TweetIconButton(icon: FontAwesomeIcons.comment, text: tweet.commentIds.length, onTap: () {}),
                                  TweetIconButton(
                                      icon: FontAwesomeIcons.retweet,
                                      text: tweet.shareCount,
                                      onTap: () {
                                        tweetController.retweet(tweet: tweet);
                                      }),
                                  LikeButton(
                                    size: 25,
                                    isLiked: isLiked.value,
                                    likeCount: tweet.likes.length,
                                    likeBuilder: (isLiked) => Icon(
                                      isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                                      color: isLiked ? Palette.redColor : Palette.greyColor,
                                      size: 20,
                                    ),
                                    animationDuration: 500.milliseconds,
                                    likeCountPadding: const EdgeInsets.only(left: 5),
                                    countBuilder: (likeCount, isLiked, text) => Text(
                                      text,
                                      style: AppTextStyles.bodySm.copyWith(color: isLiked ? Palette.redColor : Palette.greyColor),
                                    ),
                                    onTap: (isLiked) async {
                                      tweetController.likeTweet(tweet: tweet);

                                      return !isLiked;
                                    },
                                    // },
                                  ),
                                  TweetIconButton(icon: FontAwesomeIcons.shareNodes, text: null, onTap: () {}),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
            loading: () => const SizedBox(height: 100, child: AppLoader()),
          );
  }
}

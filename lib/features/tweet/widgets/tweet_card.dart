import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/common/app_loader.dart';
import 'package:twitter_clone_apps/common/simple_dot.dart';
import 'package:twitter_clone_apps/core/enums/tweet_type.dart';
import 'package:twitter_clone_apps/core/helpers/format_helper.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone_apps/models/tweet_model.dart';

class TweetCard extends HookConsumerWidget {
  const TweetCard({super.key, required this.tweet});

  final Tweet tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetail = ref.watch(userDetailProvider(tweet.uid));

    final tweetAt = useState(FormatHelper.formatDiffForHumans(tweet.tweetedAt));

    useEffect(() {
      final interval = 1.minutes.interval((timer) {
        tweetAt.value = FormatHelper.formatDiffForHumans(tweet.tweetedAt);
      });

      return interval.cancel;
    }, []);

    return userDetail.when(
      data: (user) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: user.profilePic.isEmpty
                      ? const CircleAvatar(
                          radius: 21,
                          child: HeroIcon(
                            HeroIcons.user,
                            size: 24,
                            style: HeroIconStyle.solid,
                          ),
                        )
                      : CircleAvatar(
                          radius: 21,
                          backgroundImage: NetworkImage(user.profilePic),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            tweetAt.value,
                            style: AppTextStyles.body.grey,
                          ),
                        ],
                      ),
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
                            TweetIconButton(icon: FontAwesomeIcons.retweet, text: tweet.shareCount, onTap: () {}),
                            TweetIconButton(icon: FontAwesomeIcons.heart, text: tweet.likes.length, onTap: () {}),
                            TweetIconButton(icon: FontAwesomeIcons.shareNodes, text: null, onTap: () {}),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(
              color: Palette.greyColor,
              thickness: 0.3,
            ),
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

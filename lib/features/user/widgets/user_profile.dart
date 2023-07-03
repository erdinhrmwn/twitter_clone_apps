import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/apis/storage_api.dart';
import 'package:twitter_clone_apps/common/common.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/user_avatar.dart';
import 'package:twitter_clone_apps/features/user/controller/user_controller.dart';
import 'package:twitter_clone_apps/features/user/view/edit_profile_view.dart';
import 'package:twitter_clone_apps/features/user/widgets/follow_count.dart';
import 'package:twitter_clone_apps/generated/assets.gen.dart';
import 'package:twitter_clone_apps/models/user_model.dart';

class UserProfile extends HookConsumerWidget {
  const UserProfile({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailProvider).value;

    return currentUser == null
        ? const AppLoader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: user.coverPic.isEmpty
                            ? Container(color: Palette.greyColor)
                            : CachedNetworkImage(
                                imageUrl: ref.read(storageApiProvider).getUserPicsUrl(user.coverPic),
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          child: UserAvatar(profilePic: user.profilePic, radius: 30),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: RoundedSmallButton(
                            backgroundColor: Palette.whiteColor,
                            textColor: Palette.blackColor,
                            label: currentUser.uid == user.uid
                                ? 'Edit Profile'
                                : currentUser.following.contains(user.uid)
                                    ? 'Unfollow'
                                    : 'Follow',
                            onTap: () {
                              if (currentUser.uid == user.uid) {
                                Navigator.push(context, EditProfileView.route());
                              } else {
                                ref.read(userControllerProvider.notifier).followUser(user: user);
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: AppTextStyles.bodyLg.bold,
                            ),
                            if (user.isTwitterBlue)
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Assets.icons.icVerified.svg(
                                  width: 20,
                                  height: 20,
                                  colorFilter: const ColorFilter.mode(
                                    Palette.blueColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text(
                          '@${user.name}',
                          style: AppTextStyles.body.grey,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.bio,
                          style: AppTextStyles.body,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            FollowCount(
                              count: user.following.length,
                              text: 'Following',
                            ),
                            const SizedBox(width: 15),
                            FollowCount(
                              count: user.followers.length,
                              text: 'Followers',
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          color: Palette.whiteColor,
                          thickness: 0.3,
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: ref.watch(getUserTweetsProvider(user.uid)).when(
                  data: (tweets) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                  error: (error, stackTrace) => Center(child: Text(error.toString())),
                  loading: () => const AppLoader(),
                ),
          );
  }
}

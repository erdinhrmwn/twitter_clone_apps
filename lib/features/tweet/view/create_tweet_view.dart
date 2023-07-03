import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone_apps/common/common.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/types/types.dart';
import 'package:twitter_clone_apps/core/utils/image_picker.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';
import 'package:twitter_clone_apps/core/utils/snackbar.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/user_avatar.dart';

class CreateTweetScreen extends HookConsumerWidget {
  const CreateTweetScreen({super.key});

  static route() => MaterialPageRoute(builder: (context) => const CreateTweetScreen());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetail = ref.watch(currentUserDetailProvider);
    final tweetController = ref.read(tweetControllerProvider.notifier);

    final textController = useTextEditingController();
    final isLoading = useState(false);
    final tweetImages = useState<List<XFile>>([]);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const HeroIcon(HeroIcons.xMark),
        ),
        actions: [
          RoundedSmallButton(
            isLoading: isLoading.value,
            label: "Tweet",
            onTap: () async {
              isLoading.value = true;

              final result = await tweetController.createTweet(
                text: textController.text,
                images: tweetImages.value,
              );

              result.fold((failure) {
                showSnackbar(context, failure.message);
              }, (document) {
                Navigator.pop(context);
              });

              isLoading.value = false;
            },
            backgroundColor: Palette.blueColor,
            textColor: Palette.whiteColor,
          ),
        ],
      ),
      body: SafeArea(
        child: userDetail.when(
          data: (user) => SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: UserAvatar(profilePic: user.profilePic, radius: 20),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: "What's happening?",
                          hintStyle: AppTextStyles.body.grey.bold,
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (tweetImages.value.isNotEmpty)
                  CarouselSlider.builder(
                    itemCount: tweetImages.value.length,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(File(tweetImages.value[index].path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 200,
                      viewportFraction: 0.9,
                      enableInfiniteScroll: false,
                    ),
                  ),
              ],
            ),
          ),
          loading: () => const AppLoader(),
          error: (error, stackTrace) => Center(child: Text((error as Failure).message)),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Palette.backgroundColor,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 50,
          color: Palette.backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () async {
                  tweetImages.value = await handleMultiImagePicker();
                },
                icon: const HeroIcon(
                  HeroIcons.photo,
                  size: 24,
                  style: HeroIconStyle.solid,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const HeroIcon(
                  HeroIcons.gif,
                  size: 24,
                  style: HeroIconStyle.solid,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const HeroIcon(
                  HeroIcons.faceSmile,
                  size: 24,
                  style: HeroIconStyle.solid,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const HeroIcon(
                  HeroIcons.mapPin,
                  size: 24,
                  style: HeroIconStyle.solid,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const HeroIcon(
                  HeroIcons.calendar,
                  size: 24,
                  style: HeroIconStyle.solid,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

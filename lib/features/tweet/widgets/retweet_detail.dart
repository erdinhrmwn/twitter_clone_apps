import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';

class RetweetDetail extends HookConsumerWidget {
  const RetweetDetail({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ref.watch(userDetailProvider(uid)).when(
              data: (user) {
                return Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.retweet,
                      size: 14,
                      color: Palette.greyColor,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        user.name,
                        style: AppTextStyles.bodySm,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        "@${user.uid}",
                        style: AppTextStyles.bodySm.grey.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "retweeted",
                      style: AppTextStyles.bodySm.grey,
                    ),
                  ],
                );
              },
              loading: () => const SizedBox(),
              error: (e, s) => const SizedBox(),
            ),
        const SizedBox(height: 4),
      ],
    );
  }
}

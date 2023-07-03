import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/apis/storage_api.dart';

class UserAvatar extends HookConsumerWidget {
  const UserAvatar({
    super.key,
    required this.profilePic,
    this.radius = 21,
  });

  final String profilePic;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: profilePic.isEmpty
          ? CircleAvatar(
              radius: radius,
              child: const HeroIcon(
                HeroIcons.user,
                size: 24,
                style: HeroIconStyle.solid,
              ),
            )
          : CircleAvatar(
              radius: radius,
              backgroundImage: CachedNetworkImageProvider(ref.read(storageApiProvider).getUserPicsUrl(profilePic)),
            ),
    );
  }
}

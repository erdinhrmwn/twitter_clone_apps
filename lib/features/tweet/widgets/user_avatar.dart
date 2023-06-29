import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.profilePic,
  });

  final String profilePic;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: profilePic.isEmpty
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
              backgroundImage: NetworkImage(profilePic),
            ),
    );
  }
}

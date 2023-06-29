import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.profilePic,
    this.radius = 21,
  });

  final String profilePic;
  final double radius;

  @override
  Widget build(BuildContext context) {
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
              backgroundImage: NetworkImage(profilePic),
            ),
    );
  }
}

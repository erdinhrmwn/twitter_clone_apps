import 'package:flutter/material.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';
import 'package:twitter_clone_apps/features/tweet/widgets/user_avatar.dart';
import 'package:twitter_clone_apps/models/user_model.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // Navigator.push(
        //   context,
        //   UserProfileView.route(user),
        // );
      },
      leading: UserAvatar(
        profilePic: user.profilePic,
        radius: 26,
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.name,
            style: AppTextStyles.bodyLg.bold,
          ),
          Text(
            '@${user.name}',
            style: AppTextStyles.bodyLg.grey,
          ),
        ],
      ),
    );
  }
}

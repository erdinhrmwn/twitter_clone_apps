import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/core/constants/appwrite_constants.dart';
import 'package:twitter_clone_apps/features/user/controller/user_controller.dart';
import 'package:twitter_clone_apps/features/user/widgets/user_profile.dart';
import 'package:twitter_clone_apps/models/user_model.dart';

class UserProfileView extends HookConsumerWidget {
  const UserProfileView({super.key, required this.user});

  static route(UserModel user) => MaterialPageRoute(builder: (context) => UserProfileView(user: user));

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updatedUser = useState(user);

    return Scaffold(
      body: ref.watch(streamProfileDataProvider).when(
            data: (data) {
              if (data.events.contains(
                'databases.*.collections.${AppwriteConstants.usersCollectionId}.documents.${user.uid}.update',
              )) {
                updatedUser.value = UserModel.fromJson(data.payload);
              }

              return UserProfile(user: updatedUser.value);
            },
            error: (error, st) => Center(child: Text(error.toString())),
            loading: () => UserProfile(user: updatedUser.value),
          ),
    );
  }
}

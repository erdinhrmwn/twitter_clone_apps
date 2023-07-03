import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone_apps/common/app_loader.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone_apps/features/auth/view/login_view.dart';
import 'package:twitter_clone_apps/features/user/controller/user_controller.dart';
import 'package:twitter_clone_apps/features/user/view/user_profile_view.dart';
import 'package:twitter_clone_apps/generated/assets.gen.dart';

class SideDrawer extends HookConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailProvider).value;

    if (currentUser == null) {
      return const AppLoader();
    }

    return SafeArea(
      child: Drawer(
        backgroundColor: Palette.backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: const HeroIcon(
                HeroIcons.userCircle,
                style: HeroIconStyle.solid,
                size: 24,
              ),
              title: Text(
                'My Profile',
                style: AppTextStyles.bodyLg,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  UserProfileView.route(currentUser),
                );
              },
            ),
            ListTile(
              leading: Assets.icons.icVerified.svg(
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Palette.blueColor,
                  BlendMode.srcIn,
                ),
              ),
              title: Text(
                'Twitter Blue',
                style: AppTextStyles.bodyLg,
              ),
              onTap: () {
                ref.read(userControllerProvider.notifier).updateUser(user: currentUser.copyWith(isTwitterBlue: true));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 24,
              ),
              title: Text(
                'Log Out',
                style: AppTextStyles.bodyLg,
              ),
              onTap: () async {
                final result = await ref.read(authControllerProvider.notifier).signOut();

                result.fold((failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(failure.message),
                    ),
                  );
                }, (success) {
                  Navigator.pushReplacement(context, LoginView.route());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

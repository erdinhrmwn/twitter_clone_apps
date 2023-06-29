import 'package:flutter/material.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/generated/assets.gen.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: RepaintBoundary(
        child: Assets.icons.icLogo.svg(
          height: 30,
          colorFilter: const ColorFilter.mode(
            Palette.blueColor,
            BlendMode.srcIn,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';

class TweetIconButton extends StatelessWidget {
  final IconData icon;
  final num? text;
  final VoidCallback onTap;
  const TweetIconButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: Palette.greyColor,
            size: 20,
          ),
          if (text != null)
            Container(
              margin: const EdgeInsets.all(6),
              child: Text(
                text.toString(),
                style: AppTextStyles.bodySm.grey,
              ),
            ),
        ],
      ),
    );
  }
}

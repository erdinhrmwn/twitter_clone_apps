import 'package:flutter/material.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';

class TweetIconButton extends StatelessWidget {
  final IconData icon;
  final num? text;
  final Color color;
  final VoidCallback onTap;
  const TweetIconButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.color = Palette.greyColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          if (text != null)
            Container(
              padding: const EdgeInsets.only(left: 3),
              margin: const EdgeInsets.all(6),
              child: Text(
                text.toString(),
                style: AppTextStyles.bodySm.copyWith(color: color),
              ),
            ),
        ],
      ),
    );
  }
}

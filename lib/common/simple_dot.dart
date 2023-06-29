import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';

enum SimpleDotType {
  dot,
  line,
}

class SimpleDot extends StatelessWidget {
  const SimpleDot({
    super.key,
    this.color = Palette.greyColor,
    this.size = 4,
    this.type = SimpleDotType.dot,
  });

  final Color color;
  final double size;
  final SimpleDotType type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 8),
        type == SimpleDotType.dot
            ? Icon(
                FontAwesomeIcons.solidCircle,
                size: size,
                color: color,
              )
            : Text(
                "–",
                style: AppTextStyles.body.grey,
              ),
        const SizedBox(width: 8),
      ],
    );
  }
}

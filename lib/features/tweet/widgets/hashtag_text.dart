import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];

    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textSpans.add(
          TextSpan(
            text: '$element ',
            style: AppTextStyles.body.bold.primary,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Navigator.push(
                //   context,
                //   HashtagView.route(element),
                // );
              },
          ),
        );
      } else if (element.startsWith('www.') || element.startsWith('https://')) {
        textSpans.add(
          TextSpan(
            text: '$element ',
            style: AppTextStyles.body.bold.primary,
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: '$element ',
            style: AppTextStyles.body,
          ),
        );
      }
    });

    return RichText(text: TextSpan(children: textSpans));
  }
}

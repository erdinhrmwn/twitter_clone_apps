import 'package:flutter/material.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: AppTextStyles.body),
      duration: 4.seconds,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.color = Palette.blueColor,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: 3,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:twitter_clone_apps/core/theme/theme.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Palette.greyColor.withOpacity(.5), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Palette.blueColor, width: 2),
        ),
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        hintStyle: AppTextStyles.body,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:twitter_clone_apps/core/theme/app_text_styles.dart';
import 'package:twitter_clone_apps/core/theme/color_palette.dart';
import 'package:twitter_clone_apps/core/utils/my_extensions.dart';

class RoundedSmallButton extends StatelessWidget {
  const RoundedSmallButton({
    super.key,
    required this.label,
    required this.onTap,
    this.backgroundColor = Palette.backgroundColor,
    this.textColor = Palette.whiteColor,
    this.isLoading = false,
  });

  final VoidCallback onTap;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Chip(
        side: BorderSide.none,
        label: isLoading
            ? _buildLoadingLabel()
            : Text(
                label,
                style: AppTextStyles.body.bold.copyWith(color: textColor),
              ),
        backgroundColor: backgroundColor,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  Widget _buildLoadingLabel() {
    return SizedBox(
      width: 50,
      height: 15,
      child: Center(
        child: SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            color: textColor,
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}

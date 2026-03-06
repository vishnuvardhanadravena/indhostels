import 'package:flutter/material.dart';
import 'package:indhostels/utils/theame/app_themes.dart';
import 'package:indhostels/utils/theame/dimensions.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String? iconAsset;
  final IconData? iconData;
  final VoidCallback? onPressed;

  const SocialButton({
    super.key,
    required this.text,
    this.iconAsset,
    this.iconData,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDisabled = onPressed == null;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          side: BorderSide(
            color: isDisabled ? AppColors.divider : AppColors.inputBorder,
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconAsset != null)
              Image.asset(iconAsset!, height: 20, width: 20)
            else if (iconData != null)
              Icon(
                iconData,
                size: Dimensions.iconSizeSmall,
                color: AppColors.textGrey,
              ),

            const SizedBox(width: Dimensions.paddingSizeSmall),

            Text(
              text,
              style: textTheme.titleMedium?.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

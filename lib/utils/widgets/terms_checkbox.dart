import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:indhostels/theame/app_themes.dart';
import 'package:indhostels/theame/dimensions.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool?) onChanged;
  final String prefixText;
  final String linkText;
  final VoidCallback? onLinkTap;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.prefixText = 'By signing up, you agree to our ',
    this.linkText = 'Terms & Conditions',
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 22,
          width: 22,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            side: const BorderSide(color: AppColors.divider, width: 1.5),
          ),
        ),

        SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(
          child: RichText(
            text: TextSpan(
              text: prefixText,
              style: textTheme.bodySmall?.copyWith(
                fontSize: Dimensions.fontSizeSmall,
              ),
              children: [
                TextSpan(
                  text: linkText,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onLinkTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

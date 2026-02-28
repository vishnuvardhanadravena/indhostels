import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:indhostels/theame/app_themes.dart';
import 'package:indhostels/theame/dimensions.dart';

class AuthFooterLink extends StatelessWidget {
  final String normalText;
  final String linkText;
  final VoidCallback onLinkTap;

  const AuthFooterLink({
    super.key,
    required this.normalText,
    required this.linkText,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: RichText(
        text: TextSpan(
          text: normalText,
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
              ),
              recognizer: TapGestureRecognizer()..onTap = onLinkTap,
            ),
          ],
        ),
      ),
    );
  }
}

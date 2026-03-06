import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indhostels/utils/theame/app_themes.dart';
import 'package:indhostels/utils/theame/dimensions.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showBackButton)
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: onBack ?? () => context.pop(),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              child: Container(
                height: Dimensions.heightWidth50 - 14,
                width: Dimensions.heightWidth50 - 14,
                decoration: BoxDecoration(
                  color: AppColors.primaryFaded,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: Dimensions.iconSizeSmall,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),

        SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ],
    );
  }
}

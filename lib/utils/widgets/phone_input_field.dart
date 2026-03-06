import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indhostels/utils/theame/app_themes.dart';
import 'package:indhostels/utils/theame/dimensions.dart';

class PhoneInputField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? errorText;
  final String countryCode;
  final String? flagAsset;
  final void Function(String)? onChanged;
  final VoidCallback? onCountryTap;

  const PhoneInputField({
    super.key,
    this.label = 'Phone Number',
    this.controller,
    this.errorText,
    this.countryCode = '+91',
    this.flagAsset,
    this.onChanged,
    this.onCountryTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        Text(
          label,
          style: textTheme.titleMedium?.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        /// Input Container
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.inputBg,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(
              color: errorText != null
                  ? AppColors.error
                  : AppColors.inputBorder,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              /// Country Selector
              InkWell(
                onTap: onCountryTap,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                  ),
                  child: Row(
                    children: [
                      if (flagAsset != null)
                        Image.asset(flagAsset!, height: 20)
                      else
                        const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        countryCode,
                        style: textTheme.bodyLarge?.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: Dimensions.iconSizeSmall,
                        color: AppColors.textGrey,
                      ),
                    ],
                  ),
                ),
              ),

              /// Divider
              Container(height: 24, width: 1, color: AppColors.divider),

              const SizedBox(width: Dimensions.paddingSizeSmall),

              /// Phone Input
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: onChanged,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: textTheme.bodyLarge?.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your phone number',
                    hintStyle: textTheme.bodySmall?.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                    counterText: '',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Error Text
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
            child: Text(
              errorText!,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.error,
                fontSize: Dimensions.fontSizeSmall,
              ),
            ),
          ),
      ],
    );
  }
}

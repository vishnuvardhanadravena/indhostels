import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indhostels/utils/theame/app_themes.dart';
import 'package:indhostels/utils/theame/dimensions.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? errorText;
  final Widget? prefixWidget;
  final Widget? suffixIcon;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.errorText,
    this.prefixWidget,
    this.suffixIcon,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        Text(
          widget.label,
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
              color: widget.errorText != null
                  ? AppColors.error
                  : AppColors.inputBorder,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              if (widget.prefixWidget != null) ...[
                const SizedBox(width: Dimensions.paddingSizeSmall),
                widget.prefixWidget!,
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Container(height: 24, width: 1, color: AppColors.divider),
                const SizedBox(width: Dimensions.paddingSizeSmall),
              ],

              /// TextField
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.isPassword && _obscureText,
                  maxLength: widget.maxLength,
                  inputFormatters: widget.inputFormatters,
                  onChanged: widget.onChanged,
                  focusNode: widget.focusNode,
                  textInputAction: widget.textInputAction,
                  onSubmitted: widget.onSubmitted,
                  readOnly: widget.readOnly,
                  onTap: widget.onTap,
                  style: textTheme.bodyLarge?.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: textTheme.bodySmall?.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: widget.prefixWidget != null
                        ? const EdgeInsets.symmetric(vertical: 14)
                        : const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: 14,
                          ),
                    suffixIcon: widget.isPassword
                        ? InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () =>
                                setState(() => _obscureText = !_obscureText),
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textLight,
                              size: Dimensions.iconSizeSmall,
                            ),
                          )
                        : widget.suffixIcon,
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Error Text
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(
              top: Dimensions.paddingSizeExtraSmall,
            ),
            child: Text(
              widget.errorText!,
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

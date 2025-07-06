import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cennec/modules/core/utils/app_font.dart';
import 'package:cennec/modules/core/utils/app_dimens.dart';
import 'package:cennec/modules/core/utils/common_import.dart';

class CommonTextFormField extends StatelessWidget {
  final String? label;
  final bool isOptional;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool autofocus;
  final bool enabled;
  final double borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsets? contentPadding;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const CommonTextFormField({
    super.key,
    this.label,
    this.isOptional = false,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.maxLines,
    this.inputFormatters,
    this.focusNode,
    this.nextFocusNode,
    this.autofocus = false,
    this.enabled = true,
    this.borderRadius = 12,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.onChanged,
    this.onSubmitted,
  });

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(color: color, width: 1),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: RichText(
              text: TextSpan(
                text: label,
                style: getTextStyleFromFont(AppFont.poppins, 16, Colors.black, FontWeight.w400),
                children: isOptional
                    ? [
                  TextSpan(
                    text: ' (optional)',
                    style: getTextStyleFromFont(AppFont.poppins, 14, Colors.grey, FontWeight.w400),
                  )
                ]
                    : [],
              ),
            ),
          ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLength: maxLength,
          maxLines: maxLines ?? 1,
          inputFormatters: inputFormatters,
          autofocus: autofocus,
          enabled: enabled,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: (_) => onSubmitted?.call(_),
          onEditingComplete: () {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          style: getTextStyleFromFont(AppFont.poppins, 16, Colors.black, FontWeight.w500),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: getTextStyleFromFont(AppFont.poppins, 15, theme.hintColor, FontWeight.w400),
            filled: true,
            fillColor: Colors.white,
            counterText: '',
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            enabledBorder: _border(Colors.grey.shade300),
            focusedBorder: _border(theme.primaryColor),
            disabledBorder: _border(Colors.grey.shade200),
            border: _border(Colors.grey.shade300),
            contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ],
    );
  }
}

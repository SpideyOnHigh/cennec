import 'package:flutter/services.dart';

import '../../utils/common_import.dart';
import 'base_text_field_error_indicator.dart';

class CommonPasswordTextFormField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final bool isShowPassword;
  final VoidCallback onToggleVisibility;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool autofocus;
  final bool enabled;
  final String? errorText;
  final Function(String)? onChanged;
  final Function()? onSubmitted;
  final double borderRadius;

  const CommonPasswordTextFormField({
    super.key,
    required this.label,
    required this.isShowPassword,
    required this.onToggleVisibility,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.nextFocusNode,
    this.autofocus = false,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.borderRadius = 12,
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
            child: Text(
              label!,
              style: getTextStyleFromFont(
                AppFont.poppins,
                16,
                Colors.black,
                FontWeight.w400,
              ),
            ),
          ),
        TextField(
          controller: controller,
          obscureText: !isShowPassword,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          autofocus: autofocus,
          enabled: enabled,
          focusNode: focusNode,
          onChanged: (val) => onChanged?.call(val),
          onSubmitted: (_) => onSubmitted?.call(),
          onEditingComplete: () {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          style: getTextStyleFromFont(
            AppFont.poppins,
            16,
            Colors.black,
            FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: getTextStyleFromFont(
              AppFont.poppins,
              15,
              theme.hintColor,
              FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
            counterText: '',
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                isShowPassword ? Icons.visibility_off : Icons.visibility,
                color: theme.iconTheme.color,
              ),
            ),
            enabledBorder: _border(Colors.grey.shade300),
            focusedBorder: _border(theme.primaryColor),
            disabledBorder: _border(Colors.grey.shade200),
            border: _border(Colors.grey.shade300),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
          ),
        ),
        // if (errorText != null && errorText!.isNotEmpty) ...[
        //   const SizedBox(height: Dimens.margin8),
        //   BaseTextFieldErrorIndicator(errorText: errorText),
        // ],
      ],
    );
  }
}

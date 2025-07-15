import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cennec/modules/core/utils/app_dimens.dart';
import 'package:cennec/modules/core/utils/app_font.dart';

class CommonUnderlineTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final bool enabled;
  final double fontSize;
  final FontWeight fontWeight;
  final int maxLines;
  final TextAlign textAlign;
  final Color? textColor;
  final Color? hintColor;
  final List<TextInputFormatter>? inputFormatters;

  const CommonUnderlineTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.focusNode,
    this.enabled = true,
    this.fontSize = Dimens.margin18,
    this.fontWeight = FontWeight.w500,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
    this.textColor,
    this.hintColor,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final underlineBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: enabled ? theme.colorScheme.secondary : Colors.black12,
        width: 1.2,
      ),
    );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: enabled,
      focusNode: focusNode,
      maxLines: maxLines,
      textAlign: textAlign,
      inputFormatters: inputFormatters,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: AppFont.poppins,
        color: textColor ?? (enabled ? theme.textTheme.bodyLarge?.color : Colors.black26),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: Dimens.margin12),
        hintStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: AppFont.poppins,
          color: hintColor ?? (enabled ? theme.hintColor.withOpacity(0.6) : Colors.black26),
        ),
        border: underlineBorder,
        enabledBorder: underlineBorder,
        focusedBorder: underlineBorder,
        disabledBorder: underlineBorder,
      ),
    );
  }
}

import 'package:flutter/services.dart';
import '../../utils/common_import.dart';

class BaseTextFormFieldRounded extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int? maxLine;
  final String? hintText;
  final String? titleText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? titleStyle;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextCapitalization? textCapitalization;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? enabled;
  final double? height;
  final double? borderRadius;
  final TextEditingController? controller;
  final Function? onChange;
  final Function? onSubmit;
  final bool autofocus;

  const BaseTextFormFieldRounded({
    Key? key,
    this.height,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.maxLine,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.controller,
    this.nextFocusNode,
    this.enabled,
    this.titleStyle,
    this.titleText,
    this.labelStyle,
    this.hintStyle,
    this.onChange,
    this.textCapitalization,
    this.onSubmit,
    this.autofocus = false,
    this.borderRadius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder mOutlineInputBorder() {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? Dimens.margin30),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: Dimens.margin1),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height ?? 50,
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius ?? Dimens.margin30),
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: TextField(
            maxLines: maxLine ?? 1,
            enabled: enabled ?? true,
            inputFormatters: inputFormatters ?? [],
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            maxLength: maxLength,
            autofocus: autofocus,
            focusNode: focusNode,
            controller: controller,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            onSubmitted: (val) {
              if (/*val.isNotEmpty && */onSubmit != null) {
                onSubmit!();
              }
            },
            onChanged: (val) {
              if (val.isNotEmpty && onChange != null) {
                onChange!();
              }
            },
            onEditingComplete: () {
              if (nextFocusNode != null) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              } else {
                FocusScope.of(context).unfocus();
              }
            },
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              counterText: '',
              filled: true,
              fillColor: Colors.white,
              enabledBorder: mOutlineInputBorder(),
              focusedBorder: mOutlineInputBorder(),
              disabledBorder: mOutlineInputBorder(),
              prefixIcon: prefixIcon,
              border: mOutlineInputBorder(),
              contentPadding: const EdgeInsets.all(Dimens.margin15),
              hintText: hintText,
              labelStyle: enabled == false
                  ? hintStyle
                  : labelStyle ??
                  getTextStyle(Theme.of(context).primaryTextTheme.headlineSmall!, Dimens.textSize15, FontWeight.w400),
              hintStyle: hintStyle ??
                  getTextStyleFromFont(
                      AppFont.poppins, Dimens.margin18, Theme.of(context).hintColor, FontWeight.w600),
            ),
            style: labelStyle ??
                getTextStyleFromFont(
                    AppFont.poppins, Dimens.margin18, Theme.of(context).hintColor, FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

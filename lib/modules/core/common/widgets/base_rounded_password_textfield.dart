import 'package:cennec/modules/core/common/widgets/base_text_field_error_indicator.dart';
import 'package:flutter/services.dart';
import '../../utils/common_import.dart';


class BasePasswordTextFormField extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final Function? pressShowPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final String? hintText;
  final String? titleText;
  final bool? isShowPassword;
  final String? errorText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? titleStyle;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool? enabled;
  final double? height;
  final TextEditingController? controller;
  final Function? onChange;
  final Function? onSubmit;
  final bool? isRequiredField;

  const BasePasswordTextFormField({
    super.key,
    this.height,
    this.pressShowPassword,
    this.isShowPassword = false,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.hintText,
    this.focusNode,
    this.controller,
    this.nextFocusNode,
    this.enabled,
    this.titleStyle,
    this.titleText,
    this.errorText,
    this.labelStyle,
    this.hintStyle,
    this.onChange,
    this.onSubmit,
    this.isRequiredField = false,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder() {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.margin30),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: Dimens.margin1),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height ?? Dimens.margin50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(Dimens.margin12),
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: TextField(
            maxLines: 1,
            enabled: enabled ?? true,
            inputFormatters: inputFormatters ?? [],
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            maxLength: maxLength,
            focusNode: focusNode,
            controller: controller,
            onChanged: (val) {
              if (val.isNotEmpty && onChange != null) {
                onChange!();
              }
            },
            obscureText: isShowPassword ?? true,
            onEditingComplete: () {
              if (nextFocusNode != null) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              } else {
                FocusScope.of(context).unfocus();
              }
            },
            onSubmitted: (val) {
              if (onSubmit != null) {
                onSubmit!();
              }
            },
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              suffixIcon: InkWell(
                onTap: () {
                  pressShowPassword!();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimens.margin10,
                    horizontal:  Dimens.margin0,
                  ),
                  child: Icon(
                    !isShowPassword!
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
              fillColor: Colors.white,
              enabledBorder: outlineInputBorder(),
              focusedBorder: outlineInputBorder(),
              disabledBorder: outlineInputBorder(),
              border: outlineInputBorder(),
              contentPadding: const EdgeInsets.all(Dimens.margin15),
              hintText: hintText,
              labelStyle: enabled == false
                  ? hintStyle
                  : labelStyle ??
                  getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin18 ,
                    Theme.of(context).colorScheme.primary,
                    FontWeight.w400,
                  ),
              hintStyle: hintStyle ??
                  getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin18 ,
                    Theme.of(context).colorScheme.primary,
                    FontWeight.w400,
                  ),
            ),
            style: labelStyle ??
                getTextStyleFromFont(
                    AppFont.poppins, Dimens.margin18, Theme.of(context).hintColor, FontWeight.w600)
          ),
        ),
        SizedBox(
          height: errorText != null && errorText!.isNotEmpty ? Dimens.margin9 : Dimens.margin0,
        ),
        if (errorText != null && errorText!.isNotEmpty)
          BaseTextFieldErrorIndicator(
            errorText: errorText,
          ),
      ],
    );
  }
}

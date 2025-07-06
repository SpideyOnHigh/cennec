import 'package:flutter/material.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/utils/app_dimens.dart';
import 'package:cennec/modules/core/utils/app_font.dart';

class CommonButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final bool isLoading;
  final bool isOutlined;

  const CommonButton({
    Key? key,
    this.text,
    this.child,
    this.onTap,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.isLoading = false,
    this.isOutlined = false,
  })  : assert(text != null || child != null, 'Either text or child must be provided.'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(Dimens.margin12);
    final btnHeight = height ?? Dimens.margin60;
    final btnWidth = width ?? double.infinity;

    final buttonChild = isLoading
        ? const CommonLoadingAnimation(size: 20)
        : child ??
        Text(
          text!,
          style: textStyle ??
              TextStyle(
                fontSize: Dimens.margin18,
                fontWeight: FontWeight.w600,
                fontFamily: AppFont.poppins,
                color: textColor ?? (isOutlined ? Colors.white : Theme.of(context).primaryColor),
              ),
        );

    final style = isOutlined
        ? OutlinedButton.styleFrom(
      padding: padding ?? const EdgeInsets.symmetric(vertical: Dimens.margin15),
      shape: RoundedRectangleBorder(borderRadius: radius),
      side: BorderSide(color: borderColor ?? Colors.white),
    )
        : ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.onPrimary,
      padding: padding ?? const EdgeInsets.symmetric(vertical: Dimens.margin15),
      shape: RoundedRectangleBorder(borderRadius: radius),
    );

    return SizedBox(
      width: btnWidth,
      height: btnHeight,
      child: isOutlined
          ? OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: style,
        child: buttonChild,
      )
          : ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: style,
        child: buttonChild,
      ),
    );
  }
}

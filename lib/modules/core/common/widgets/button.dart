// import '../../api_service/common_service.dart';
// import '../../utils/app_colors.dart';
// import '../../utils/common_import.dart';
//
// /// A [CustomButton] widget is a widget that describes part of the user interface by button
// /// * [buttonText] which contains the button Text
// /// * [height] which contains the button height
// /// * [width] which contains the button width
// /// * [backgroundColor] which contains the button backgroundColor
// /// * [borderColor] which contains the button borderColor
// /// * [borderRadius] which contains the button borderRadius
// /// * [onPress] which contains the button onPress
// /// * [style] which contains the button TextStyle
// // ignore: must_be_immutable
// class CustomButton extends StatelessWidget {
//   CustomButton({
//     Key? key,
//     this.buttonText,
//     this.height,
//     this.width,
//     this.backgroundColor,
//     this.borderColor,
//     this.borderRadius,
//     this.onPress,
//     this.style,
//     this.isLoading = false,
//   }) : super(key: key);
//
//   String? buttonText;
//   double? height;
//   double? width;
//   Color? backgroundColor;
//   Color? borderColor;
//   double? borderRadius;
//   TextStyle? style;
//   final bool isLoading;
//   final Function? onPress;
//
//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? Container(
//             height: height ?? 50,
//             width: width ?? MediaQuery.of(context).size.width,
//             alignment: Alignment.center,
//             child: CircularProgressIndicator(
//               color: backgroundColor,
//             ),
//           )
//         : InkWell(
//             borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0)),
//             splashColor: AppColors.colorTransparent,
//             hoverColor: AppColors.colorTransparent,
//             highlightColor: AppColors.colorTransparent,
//             onTap: () {
//               onPress!();
//             },
//             child: Container(
//               alignment: Alignment.center,
//               padding: EdgeInsets.zero,
//               height: height ?? 50,
//               width: width ?? MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0)),
//                 color: backgroundColor ?? Theme.of(context).primaryColor,
//                 border: Border.all(color: borderColor ?? Theme.of(context).primaryColor),
//               ),
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Text(
//                   '$buttonText',
//                   style: style ??
//                       getTextStyle(
//                           Theme.of(context).primaryTextTheme.headlineSmall!, 14, FontWeight.w300),
//                 ),
//               ),
//             ),
//           );
//   }
// }
//
// /// A [CustomButton] widget is a widget that describes part of the user interface by button
// /// * [buttonText] which contains the button Text
// /// * [height] which contains the button height
// /// * [width] which contains the button width
// /// * [backgroundColor] which contains the button backgroundColor
// /// * [borderColor] which contains the button borderColor
// /// * [borderRadius] which contains the button borderRadius
// /// * [onPress] which contains the button onPress
// /// * [style] which contains the button TextStyle
// /// * [Widget] for widgets that always build the same way given a
// // ignore: must_be_immutable
// class CustomChildButton extends StatelessWidget {
//   CustomChildButton({
//     Key? key,
//     this.buttonText,
//     this.height,
//     this.width,
//     this.backgroundColor,
//     this.borderColor,
//     this.borderRadius,
//     this.onPress,
//     this.style,
//     this.isLoading = false,
//     this.child,
//   }) : super(key: key);
//
//   String? buttonText;
//   double? height;
//   double? width;
//   final bool? isLoading;
//   Color? backgroundColor;
//   Color? borderColor;
//   double? borderRadius;
//   Widget? child;
//   TextStyle? style;
//   final Function? onPress;
//
//   @override
//   Widget build(BuildContext context) {
//     return isLoading!
//         ? Container(
//             height: height ?? 50,
//             width: width ?? MediaQuery.of(context).size.width,
//             alignment: Alignment.center,
//             child: CircularProgressIndicator(
//               color: Theme.of(context).primaryColor,
//             ),
//           )
//         : InkWell(
//             onTap: () {
//               onPress!();
//             },
//             splashColor: AppColors.colorTransparent,
//             hoverColor: AppColors.colorTransparent,
//             borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0)),
//             child: Container(
//               alignment: Alignment.center,
//               height: height ?? 50,
//               width: width ?? MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0)),
//                 color: backgroundColor ?? Theme.of(context).dialogBackgroundColor,
//                 border: Border.all(color: borderColor ?? Theme.of(context).dialogBackgroundColor),
//               ),
//               child: child,
//             ),
//           );
//   }
// }

import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/utils/app_dimens.dart';
import 'package:cennec/modules/core/utils/app_font.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final double? height;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;

  const CommonButton({
    Key? key,
    required this.text,
    this.onTap,
    this.height,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.textStyle,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CommonLoadingAnimation(),
          )
        : SizedBox(
            width: double.maxFinite,
            height: height ?? Dimens.margin60,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.onPrimary,
                padding: padding ?? const EdgeInsets.symmetric(vertical: Dimens.margin15),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(Dimens.margin30),
                ),
              ),
              child: Text(
                text,
                style: textStyle ??
                    TextStyle(fontSize: Dimens.margin18, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600, fontFamily: AppFont.poppins),
              ),
            ),
          );
  }
}

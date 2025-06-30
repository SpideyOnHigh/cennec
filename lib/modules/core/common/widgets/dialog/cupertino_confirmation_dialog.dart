import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:flutter/cupertino.dart';

class CupertinoConfirmationDialog extends StatefulWidget {
  final String title;
  final String cancelText;
  final String confirmText;
  final String description;
  final Function onCancel;
  final Function onConfirm;
  final TextStyle? cancelTextStyle;
  final TextStyle? confirmTextStyle;
  const CupertinoConfirmationDialog({super.key,
    required this.title,this.cancelTextStyle,this.confirmTextStyle, required this.cancelText, required this.confirmText, required this.description, required this.onCancel, required this.onConfirm});

  @override
  State<CupertinoConfirmationDialog> createState() => _CupertinoConfirmationDialogState();
}

class _CupertinoConfirmationDialogState extends State<CupertinoConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return // Show a Cupertino-style dialog box
      CupertinoAlertDialog(
        // Add a title to the dialog with the 'Logout?' text, using the textTheme to apply styles
        title: Text(
          widget.title,
          style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, CupertinoColors.black,FontWeight.w700)
        ),
        // Add content to the dialog with the 'Are you sure want to logout?' text, using the textTheme to apply styles
        content: Text(
           widget.description,
          style: getTextStyleFromFont(AppFont.poppins, Dimens.margin16, CupertinoColors.black.withOpacity(0.8),FontWeight.w600),
        ),
        // Add two actions to the dialog: Cancel and Logout
        actions: [
          CupertinoDialogAction(
            child: Text(
             widget.cancelText,
              style: widget.cancelTextStyle ??  getTextStyleFromFont(AppFont.poppins, Dimens.margin18, CupertinoColors.activeBlue,FontWeight.w700),
            ),
            onPressed: () {
              widget.onCancel();
              // Handle the 'Cancel' action by dismissing the dialog
            },
          ),
          CupertinoDialogAction(
            child: Text(
             widget.confirmText,
                style: widget.confirmTextStyle ??getTextStyleFromFont(AppFont.poppins, Dimens.margin18, CupertinoColors.activeBlue,FontWeight.w600)
            ),
            onPressed: () {
              widget.onConfirm();
              // Handle the 'Logout' action by dismissing the dialog
            },
          ),
        ],
      );
  }
}


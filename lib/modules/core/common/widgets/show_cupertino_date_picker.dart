import 'dart:ui' show ImageFilter;
export 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart'
    show
        Alignment,
        Border,
        BorderSide,
        BoxDecoration,
        BuildContext,
        Color,
        Column,
        Container,
        CrossAxisAlignment,
        CupertinoDatePicker,
        CupertinoDatePickerMode,
        EdgeInsets,
        Expanded,
        Key,
        Navigator,
        SizedBox,
        Widget,
        required,
        showCupertinoModalPopup;

import '../../utils/common_import.dart';

/// It shows a CupertinoDatePicker in a CupertinoModalPopup.
///
/// Args:
///   context (BuildContext): The context of the widget that is calling the showCupertinoDatePicker
/// function.
///   key (Key): The key to use for the CupertinoDatePicker.
///   mode (CupertinoDatePickerMode): The mode of the picker. Defaults to CupertinoDatePickerMode
///   onDateTimeChanged (Function(DateTime value)?): This is the callback that will be called when the
/// user selects a date.
///   initialDateTime (DateTime): The initial date to display when the picker is shown.
///   minimumDate (DateTime): The earliest date the user is permitted to pick.
///   maximumDate (DateTime): The maximum date that the user can pick to.
///   minimumYear (int): The minimum year that can be selected. Defaults to 1
///   maximumYear (int): The maximum year that can be selected.
///   minuteInterval (int): The minute interval to snap to. For example, if it is 5, then the picker
/// will snap to 5-minute intervals. Defaults to 1
///   use24hFormat (bool): If true, the picker will use a 24-hour format. Otherwise, it will use AM/PM.
/// Defaults to false
///   backgroundColor (Color): The background color of the date picker.
///   filter (ImageFilter): ImageFilter?
///   useRootNavigator (bool): If true, the topmost [Navigator] is used to display the dialog.
/// Otherwise, [Navigator.of] is used with the context argument. Defaults to true
///   semanticsDismissible (bool): If true, the semantics label for the modal barrier will indicate that
/// the barrier can be dismissed by gesture.
///   cancelText (Widget): The text to display on the cancel button.
///   doneText (Widget): The text to display on the "done" button.
///   useText (bool): If true, the picker will use text instead of icons. Defaults to false
///   leftHanded (bool): If true, the picker will be on the left side of the screen. Defaults to false
///
/// Returns:
///   A CupertinoDatePicker
void showCupertinoDatePicker(
  BuildContext context, {
  Key? key,
  CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime,
  @required Function(DateTime value)? onDateTimeChanged,
  DateTime? initialDateTime,
  DateTime? minimumDate,
  DateTime? maximumDate,
  int minimumYear = 1,
  int? maximumYear,
  int minuteInterval = 1,
  bool use24hFormat = false,
  Color? backgroundColor,
  ImageFilter? filter,
  bool useRootNavigator = true,
  bool? semanticsDismissible,
  Widget? cancelText,
  Widget? doneText,
  bool useText = false,
  bool leftHanded = false,
}) {
  // Default to right now.
  initialDateTime ??= DateTime.now();
  showCupertinoModalPopup(
    context: context,
    builder: (context) => SizedBox(
      height: 240.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.colorWhite,
              border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.white),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 5,
                width: 50,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.5),
                  color: AppColors.colorGreyLight,
                  border: const Border(
                    bottom: BorderSide(width: 0.5, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child: CupertinoDatePicker(
            key: key,
            mode: mode,
            onDateTimeChanged: (DateTime value) {
              if (onDateTimeChanged == null) return;
              if (mode == CupertinoDatePickerMode.time) {
                onDateTimeChanged(DateTime(0000, 01, 01, value.hour, value.minute));
              } else {
                onDateTimeChanged(value);
              }
            },
            initialDateTime: initialDateTime,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            minimumYear: minimumYear,
            maximumYear: maximumYear,
            minuteInterval: minuteInterval,
            use24hFormat: use24hFormat,
            backgroundColor: AppColors.colorWhite,
          )),
        ],
      ),
    ),
    filter: filter,
    useRootNavigator: useRootNavigator,
    semanticsDismissible: semanticsDismissible!,
  );
}

import 'package:cennec/modules/core/api_service/common_service.dart';
import 'package:cennec/modules/core/utils/app_dimens.dart';
import 'package:cennec/modules/core/utils/app_font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseDatePicker extends StatefulWidget {
  final DateTime? initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final Function(DateTime)? onDateTimeChanged;
  final double? borderRadius;
  final String? hintText;
  final String? errorText;
  final TextStyle? hintStyle;
  final bool? enabled;
  final double? height;

  const BaseDatePicker({
    Key? key,
    this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
    this.borderRadius,
    this.onDateTimeChanged,
    this.hintText,
    this.errorText,
    this.hintStyle,
    this.enabled = true,
    this.height,
  }) : super(key: key);

  @override
  _BaseDatePickerState createState() => _BaseDatePickerState();
}

class _BaseDatePickerState extends State<BaseDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDateTime ?? DateTime.now().subtract(const Duration(days: 365 * 18));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height ?? 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.0),
            color: Colors.white,
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 1.0,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: widget.enabled == true ? () => _showDatePicker(context) : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    widget.hintText ?? 'Select Date',
                    style: widget.hintStyle ??
                        TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(
                    CupertinoIcons.calendar,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 9.0),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: CupertinoColors.destructiveRed),
            ),
          ),
      ],
    );
  }

  void _showDatePicker(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime eighteenYearsAgo = today.subtract(const Duration(days: 365 * 18));

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          height: 355,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.resolveFrom(context),
                    borderRadius: BorderRadius.circular(Dimens.margin15)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: CupertinoDatePicker(
                        initialDateTime: widget.initialDateTime != null && widget.initialDateTime!.isBefore(eighteenYearsAgo)
                            ? widget.initialDateTime
                            : eighteenYearsAgo,
                        mode: CupertinoDatePickerMode.date,
                        dateOrder: DatePickerDateOrder.mdy,
                        minimumDate: today.subtract(const Duration(days: 365 * 100)), // Optional: Limit to 100 years ago
                        maximumDate: eighteenYearsAgo, // 18 years before today
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() {
                            _selectedDate = newDate;
                          });
                        },
                      ),
                    ),
                    Divider(color: Theme.of(context).dividerColor,),
                    CupertinoButton(
                      child: Text('Confirm', style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, CupertinoColors.activeBlue, FontWeight.w600)),
                      onPressed: () {
                        widget.onDateTimeChanged?.call(_selectedDate);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimens.margin5,),
              Container(
                decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.resolveFrom(context),
                    borderRadius: BorderRadius.circular(Dimens.margin15)
                ),
                height: 50,
                width: double.maxFinite,
                child: CupertinoButton(
                  child: Text('Cancel', style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, CupertinoColors.activeBlue, FontWeight.w700)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

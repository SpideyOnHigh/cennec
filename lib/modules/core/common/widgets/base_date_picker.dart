import 'package:flutter/cupertino.dart';

import '../../utils/common_import.dart';

class BaseDatePicker extends StatefulWidget {
  final DateTime? initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final Function(DateTime)? onDateTimeChanged;
  final double? borderRadius;
  final String? label;
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
    this.label,
    this.enabled = true,
    this.height,
  }) : super(key: key);

  @override
  _BaseDatePickerState createState() => _BaseDatePickerState();
}

class _BaseDatePickerState extends State<BaseDatePicker> {
  late DateTime _selectedDate;

  String _formattedDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }


  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDateTime ??
        DateTime.now().subtract(const Duration(days: 365 * 18));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = widget.enabled ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.label!,
              style: getTextStyleFromFont(
                AppFont.poppins,
                16,
                Colors.black,
                FontWeight.w400,
              ),
            ),
          ),
        GestureDetector(
          onTap: isEnabled ? () => _showDatePicker(context) : null,
          child: Container(
            height: widget.height ?? 50.0,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
              color: isEnabled ? Colors.white : Colors.grey.shade100,
              border: Border.all(
                color: theme.colorScheme.secondary,
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.hintText ?? _formattedDate(_selectedDate),

                  style: widget.hintStyle ??
                      getTextStyleFromFont(
                        AppFont.poppins,
                        15,
                        isEnabled
                            ? theme.hintColor
                            : theme.disabledColor.withOpacity(0.7),
                        FontWeight.w400,
                      ),
                ),
                Icon(
                  CupertinoIcons.calendar,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.errorText!,
              style: getTextStyleFromFont(
                AppFont.poppins,
                13,
                CupertinoColors.systemRed,
                FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  void _showDatePicker(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime eighteenYearsAgo =
    today.subtract(const Duration(days: 365 * 18));

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
                  borderRadius: BorderRadius.circular(Dimens.margin15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: CupertinoDatePicker(
                        initialDateTime: widget.initialDateTime != null &&
                            widget.initialDateTime!.isBefore(
                                eighteenYearsAgo)
                            ? widget.initialDateTime
                            : eighteenYearsAgo,
                        mode: CupertinoDatePickerMode.date,
                        dateOrder: DatePickerDateOrder.mdy,
                        minimumDate:
                        today.subtract(const Duration(days: 365 * 100)),
                        maximumDate: eighteenYearsAgo,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() {
                            _selectedDate = newDate;
                          });
                        },
                      ),
                    ),
                    Divider(color: Theme.of(context).dividerColor),
                    CupertinoButton(
                      child: Text(
                        'Confirm',
                        style: getTextStyleFromFont(
                          AppFont.poppins,
                          Dimens.margin18,
                          CupertinoColors.activeBlue,
                          FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        widget.onDateTimeChanged?.call(_selectedDate);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimens.margin5),
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(Dimens.margin15),
                ),
                height: 50,
                width: double.infinity,
                child: CupertinoButton(
                  child: Text(
                    'Cancel',
                    style: getTextStyleFromFont(
                      AppFont.poppins,
                      Dimens.margin18,
                      CupertinoColors.activeBlue,
                      FontWeight.w700,
                    ),
                  ),
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

import 'package:cennec/modules/core/common/widgets/base_text_field_error_indicator.dart';
import 'package:cennec/modules/core/utils/app_constant.dart';
import '../../utils/common_import.dart';

class GenderDropdown extends StatefulWidget {
  final String? hintText;
  final Function(GenderModel)? onChanged;
  final String? errorText;
  final double? height;
  final double? borderRadius;

  const GenderDropdown({
    Key? key,
    this.hintText,
    this.onChanged,
    this.errorText,
    this.borderRadius,
    this.height,
  }) : super(key: key);

  @override
  _GenderDropdownState createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  GenderModel? _selectedGender;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.hintText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.hintText!,
              style: getTextStyleFromFont(
                AppFont.poppins,
                16,
                Colors.black,
                FontWeight.w400,
              ),
            ),
          ),
        Container(
          height: widget.height ?? Dimens.margin50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? Dimens.margin12,
            ),
            border: Border.all(
              color: theme.colorScheme.secondary,
              width: 1.0,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<GenderModel>(
              isExpanded: true,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(Dimens.margin20),
              value: _selectedGender,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: getTextStyleFromFont(
                AppFont.poppins,
                16,
                Colors.black,
                FontWeight.w500,
              ),
              hint: Text(
                'Select Gender',
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  15,
                  theme.hintColor,
                  FontWeight.w400,
                ),
              ),
              onChanged: (GenderModel? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(newValue!);
                }
              },
              items: gendersList.map<DropdownMenuItem<GenderModel>>(
                    (GenderModel value) {
                  return DropdownMenuItem<GenderModel>(
                    value: value,
                    child: Text(value.genderString ?? ''),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: Dimens.margin9),
            child: BaseTextFieldErrorIndicator(
              errorText: widget.errorText,
            ),
          ),
      ],
    );
  }
}

class GenderModel {
  String? genderString;
  int? type;

  GenderModel({this.genderString, this.type});
}

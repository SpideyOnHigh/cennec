import 'package:cennec/modules/core/common/widgets/base_text_field_error_indicator.dart';
import 'package:cennec/modules/core/utils/app_constant.dart';
import '../../utils/common_import.dart';

class SmokeDropdown extends StatefulWidget {
  final String? hintText;
  final Function(SmokeModel)? onChanged;
  final String? errorText;
  final double? height;
  final double? borderRadius;

  const SmokeDropdown({
    Key? key,
    this.hintText,
    this.onChanged,
    this.errorText,
    this.borderRadius,
    this.height,
  }) : super(key: key);

  @override
  _SmokeDropdownState createState() => _SmokeDropdownState();
}

class _SmokeDropdownState extends State<SmokeDropdown> {
  SmokeModel? _selectedGender;



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height ?? Dimens.margin50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? Dimens.margin30),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: Dimens.margin1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<SmokeModel>(
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(Dimens.margin20),
                isExpanded: true,
                value: _selectedGender,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin18,
                  Theme.of(context).hintColor,
                  FontWeight.w600,
                ),
                hint: Text(
                  widget.hintText ?? 'Select Gender',
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin18,
                    Theme.of(context).hintColor,
                    FontWeight.w600,
                  ),
                ),
                onChanged: (SmokeModel? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(newValue!);
                  }
                },
                items: smokeList.map<DropdownMenuItem<SmokeModel>>((SmokeModel value) {
                  return DropdownMenuItem<SmokeModel>(
                    value: value,
                    child: Text(value.smoke ?? ''),
                  );
                }).toList(),
              ),
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

class SmokeModel {
   String? smoke;
   int? type;

  SmokeModel({ this.smoke,  this.type});
}

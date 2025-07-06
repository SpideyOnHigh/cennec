import 'package:cennec/modules/core/utils/app_font.dart';
import 'package:flutter/material.dart';

import '../../api_service/common_service.dart';
import '../../utils/app_dimens.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double size ;
  final FontWeight fontWeight ;
  final Color color;
  final String fontFamily ;

  const CommonText(
      {super.key,
      required this.text,
      this.color = Colors.white,
      this.fontWeight = FontWeight.w600,
      this.fontFamily = AppFont.poppins,
      this.size = Dimens.textSize20});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: getTextStyleFromFont(
      fontFamily,
      size,
      color,
      fontWeight,
    ),);
  }
}

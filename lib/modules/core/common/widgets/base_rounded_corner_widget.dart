import 'package:cennec/modules/core/common/widgets/common_text.dart';
import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../api_service/common_service.dart';

class BaseRoundedBackgroundWidget extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final String? appBarText;

  const BaseRoundedBackgroundWidget(
      {super.key,
      required this.child,
      this.borderRadius = 20,
      this.backgroundColor = AppColors.colorRoundedBgContainer,
      this.padding = const EdgeInsets.all(20),
      this.margin = const EdgeInsets.only(top: 16),
      this.appBarText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarText != null
          ? AppBar(
              elevation: 0,
              title: CommonText(
                text: appBarText ?? "",
              ),
              centerTitle: true,
            )
          : null,
      backgroundColor: AppColors.colorDarkBlue,
      body: Container(
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: child),
    );
  }
}

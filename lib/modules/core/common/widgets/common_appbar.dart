import 'package:flutter/material.dart';

import '../../api_service/common_service.dart';
import '../../utils/app_dimens.dart';
import '../../utils/app_font.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const CommonAppBar({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: onBack ?? () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin20,
                  Theme.of(context).colorScheme.onSecondary,
                  FontWeight.w400,
                ),
              ),
            ),
            // const SizedBox(width: 40), // To balance alignment
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

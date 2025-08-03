import '../../utils/common_import.dart';
import 'package:flutter/services.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? action;
  final Color? statusBarColor;
  final Brightness? statusBarIconBrightness;

  const CommonAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.action,
    this.statusBarColor,
    this.statusBarIconBrightness,
  });

  @override
  Widget build(BuildContext context) {
    // Configure system chrome for status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColor ?? Colors.transparent,
      statusBarIconBrightness: statusBarIconBrightness ??
          (Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark),
      statusBarBrightness: statusBarIconBrightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    ));

    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: onBack ?? () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back),
              ),
            ),
            Center(
              child: Text(
                title,
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin20,
                  Theme.of(context).colorScheme.onSecondary,
                  FontWeight.w500,
                ),
              ),
            ),
            if (action != null)
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: action!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
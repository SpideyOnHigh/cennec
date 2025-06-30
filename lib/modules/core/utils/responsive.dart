import 'package:flutter/material.dart';

/// > This class is a stateless widget that takes in a builder function and returns a widget
/// It takes two widgets, one for mobile and one for desktop, and returns the appropriate widget based
/// on the screen size
class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    required this.desktop,
  }) : super(key: key);

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isMobileTablet, isDesktop help us later
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;

  static bool isMobileTabletView(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 650;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // If our width is more than 1100 then we consider it a desktop
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop;
        }
        // If width it less then 1100 and more then 650 we consider it as tablet mobile
        else if (constraints.maxWidth >= 650) {
          return mobile;
        }
        // Or less then that we called it mobile
        else {
          return mobile;
        }
      },
    );
  }
}

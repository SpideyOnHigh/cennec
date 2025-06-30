import 'package:flutter/widgets.dart';

/// It's a PageRouteBuilder that takes a widget and a route name as parameters and returns a
/// PageRouteBuilder with the given widget and route name
/// > GeneratePageRoute is a PageRouteBuilder that takes a widget and a route name and returns a
/// MaterialPageRoute
class GeneratePageRoute extends PageRouteBuilder {
  final Widget widget;
  final String routeName;
  GeneratePageRoute({required this.widget, required this.routeName})
      : super(
            settings: RouteSettings(name: routeName),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionDuration: const Duration(milliseconds: 0),
            transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) {
              return child /*SlideTransition(
          textDirection: TextDirection.rtl,
          position: Tween<Offset>(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        )*/
                  ;
            });
}

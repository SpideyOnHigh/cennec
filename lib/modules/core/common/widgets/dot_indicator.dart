import 'package:flutter/material.dart';

/// A pink dot with a white border.
/// A widget that displays a dot indicator for a page view
class DotIndicator extends StatelessWidget {
  const DotIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.pink, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.pink,
            ),
          ),
        ),
      ),
    );
  }
}

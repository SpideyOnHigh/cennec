import 'package:flutter/material.dart';

/// This is a widget that displays a circle with a border.
/// `OutlinedDotIndicator` is a stateless widget that displays a dot with an outline
class OutlinedDotIndicator extends StatelessWidget {
  const OutlinedDotIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: const Text(''),
      ),
    );
  }
}

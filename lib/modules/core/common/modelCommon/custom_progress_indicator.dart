import '../../utils/common_import.dart';

///[CustomProgressIndicator] this  class use to Custom Progress Indicator
/// This class is a stateless widget that displays a progress indicator
/// It's a custom progress indicator that takes in a height, width, and color
class CustomProgressIndicator extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? indicatorColor;

  const CustomProgressIndicator({Key? key, this.height, this.width, this.indicatorColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            indicatorColor ?? Theme.of(context).dividerColor,
          ),
          backgroundColor: Colors.transparent),
    );
  }
}

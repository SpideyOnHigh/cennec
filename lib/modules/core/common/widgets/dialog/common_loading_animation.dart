import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CommonLoadingAnimation extends StatelessWidget {
  final double? size;
  final Color? color;
  const CommonLoadingAnimation({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: size ?? Dimens.margin50,
    );
  }
}

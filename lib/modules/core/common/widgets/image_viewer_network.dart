import 'package:cached_network_image/cached_network_image.dart';
import 'package:cennec/modules/core/common/widgets/progress_indicator_widget.dart';

import '../../utils/common_import.dart';

/// [ImageViewerNetwork] which is a  use to Circle Image Viewer Network
/// [String] which is a url
/// [Function] that a click event.
/// [double] that a mHeight of image
class ImageViewerNetwork extends StatelessWidget {
  final String? url;
  final Function? onPressed;
  final double? mHeight;
  final double? mWidth;
  final BoxFit? mFit;

  const ImageViewerNetwork({
    Key? key,
    required this.url,
    required this.mHeight,
    this.mFit,
    required this.mWidth,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        height: mHeight,
        width: mWidth,
        fit: mFit ?? BoxFit.cover,//todo to add placeholder
        // errorWidget: (context, url, error) => Image.asset(
        //       APPImages.icPlaceholder,
        //       height: mHeight,
        //       width: mWidth,
        //       fit: mFit ?? BoxFit.cover,
        //     ),
        placeholder: (context, url) => SizedBox(
              height: mHeight,
              width: mWidth,
              child: const Center(child: ProgressIndicatorWidget()),
            ),
        imageUrl: url!);
  }
}

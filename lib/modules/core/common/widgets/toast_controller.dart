//
// import '../../utils/common_import.dart';
//
// /// A [ToastController] widget is a widget that describes part of the user interface by ToastController
// /// * [mModelStaffMember] which contains the Toast Text
// /// * [BuildContext] which contains the Toast context
// /// * [bool] which contains the isSuccess or not
// class ToastController {
//   static showToast( BuildContext context ,String message, bool isSuccess, {int time = 2}) {
// /*    if (kIsWeb) {
//       Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 4,
//           backgroundColor: Colors.black,
//           textColor: Colors.white,
//           webShowClose: true,
//           webPosition: 'center',
//           webBgColor: isSuccess
//               ? 'linear-gradient(to right, #2E7D32, #2E7D32)'
//               : 'linear-gradient(to right, #fe4f4f, #fe4f4f)',
//           fontSize: 16.0);
//     } else {*/
//       final snackBar = SnackBar(
//         content: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(Dimens.margin10),
//             color:isSuccess ? Colors.green : Colors.red
//           ),
//           child: Row(mainAxisSize: MainAxisSize.min,
//             children: [
//              const SizedBox(width: Dimens.margin5,),
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(Dimens.margin16),
//                     child: Text(
//                       message,
//                       style: getTextStyleFromFont(
//                         AppFont.poppins,
//                           Dimens.margin18,
//                           Theme.of(NavigatorKey.navigatorKey.currentContext!).colorScheme.onSecondary,
//                           FontWeight.w600),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//          elevation: 0,
//          backgroundColor:  Colors.transparent,
//         duration: Duration(seconds: time),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     // }
//   }
//
//   static removeToast(BuildContext context) {
//     // if (kIsWeb) {
//     //   Fluttertoast.cancel();
//     // } else {
//       ScaffoldMessenger.of(context).clearSnackBars();
//     // }
//   }
// }
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../../utils/common_import.dart';

/// A [ToastController] widget is a widget that describes part of the user interface by ToastController
/// * [mModelStaffMember] which contains the Toast Text
/// * [BuildContext] which contains the Toast context
/// * [bool] which contains the isSuccess or not
class ToastController {
  static showToast(BuildContext context, String message, bool isSuccess, {int time = 2}) {
    showToastWidget(
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSuccess ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      context: context,
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.slideToTop,
      position: StyledToastPosition.top,
      animDuration: const Duration(milliseconds: 300),
      duration: Duration(seconds: time),
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );
  }

  static removeToast(BuildContext context) {
    ToastManager().dismissAll(showAnim: true);
  }
}
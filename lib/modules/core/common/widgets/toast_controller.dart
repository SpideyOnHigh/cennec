
import '../../utils/common_import.dart';

/// A [ToastController] widget is a widget that describes part of the user interface by ToastController
/// * [mModelStaffMember] which contains the Toast Text
/// * [BuildContext] which contains the Toast context
/// * [bool] which contains the isSuccess or not
class ToastController {
  static showToast( BuildContext context ,String message, bool isSuccess, {int time = 2}) {
/*    if (kIsWeb) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          webShowClose: true,
          webPosition: 'center',
          webBgColor: isSuccess
              ? 'linear-gradient(to right, #2E7D32, #2E7D32)'
              : 'linear-gradient(to right, #fe4f4f, #fe4f4f)',
          fontSize: 16.0);
    } else {*/
      final snackBar = SnackBar(
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.margin10),
            color:isSuccess ? Colors.green : Colors.red
          ),
          child: Row(mainAxisSize: MainAxisSize.min,
            children: [
             const SizedBox(width: Dimens.margin5,),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.margin16),
                    child: Text(
                      message,
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                          Dimens.margin18,
                          Theme.of(NavigatorKey.navigatorKey.currentContext!).colorScheme.onSecondary,
                          FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
         elevation: 0,
         backgroundColor:  Colors.transparent,
        duration: Duration(seconds: time),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }
  }

  static removeToast(BuildContext context) {
    // if (kIsWeb) {
    //   Fluttertoast.cancel();
    // } else {
      ScaffoldMessenger.of(context).clearSnackBars();
    // }
  }
}

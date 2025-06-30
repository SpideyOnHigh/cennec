import '../../../utils/common_import.dart';

/// [CustomAlertDialog] class is used Custom Alert Dialog
class CustomAlertDialog {
  static final CustomAlertDialog _instance = CustomAlertDialog.internal();

  CustomAlertDialog.internal();

  factory CustomAlertDialog() => _instance;

  static void showCustomDialog(BuildContext context,
      {String? title,
      @required String? content,
      @required String? okBtnText,
      String? cancelBtnText,
      @required VoidCallback? okBtnFunction,
      VoidCallback? cancelBtnFunction}) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimens.margin10))),
            content:
                SizedBox() /*Container(
              width: MediaQuery.of(context).size.width,
              height: Dimens.margin180,
              padding: const EdgeInsets.symmetric(horizontal: Dimens.margin20),
              decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(Dimens.margin10),
                  border: Border.all(color: AppColors.colorGrey)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: Dimens.margin20,
                  ),
                  text(
                    title!,
                    TextAlign.left,
                    AppFont.regularColorBlack_14,
                  ),
                  const SizedBox(
                    height: Dimens.margin17,
                  ),
                  text(
                    content!,
                    TextAlign.left,
                    AppFont.regularColorBlack_14,
                  ),
                  const SizedBox(
                    height: Dimens.margin17,
                  ),
                  CustomButton(
                    buttonText: okBtnText!,
                    height: Dimens.margin40,
                    width: double.infinity,
                    backgroundColor: AppColors.colorPrimary,
                    borderColor: AppColors.colorPrimary,
                    borderRadius: Dimens.margin8,
                    onPress: () {
                      okBtnFunction!();
                    },
                    style: AppFont.regularColorBlack_14,
                  ),
                  const SizedBox(
                    height: Dimens.margin24,
                  ),
                ],
              ),
            )*/
            ,
          );
        });
  }
}

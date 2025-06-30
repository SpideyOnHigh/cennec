import 'package:cennec/modules/cms_pages/bloc/get_cms_page_bloc.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:flutter_html/flutter_html.dart';

class ScreenCommunityGuidelines extends StatefulWidget {
  const ScreenCommunityGuidelines({super.key});

  @override
  State<ScreenCommunityGuidelines> createState() => _ScreenCommunityGuidelinesState();
}

class _ScreenCommunityGuidelinesState extends State<ScreenCommunityGuidelines> {



  @override
  void initState() {
    getPage();
    super.initState();
  }



  Widget logo() {
    return Image.asset(
      APPImages.icLogoWithName, // Update with your logo path
      height: 100,
    );
  }

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String> content = ValueNotifier('');

  Widget communityGuidelinesTitle(BuildContext context) {
    return Text(
      getTranslate(APPStrings.textCG).toString(),
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin40,
        AppColors.colorDarkBlue,
        FontWeight.w700,
      ),
    );
  }

/*  Widget nextButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: Dimens.margin50,
      child: ElevatedButton(
        onPressed: () {
            Navigator.pushNamed(context, AppRoutes.routesScreenSignupInterests);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          getTranslate(APPStrings.textLetsCennec),
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin18,
            Theme.of(context).primaryColor,
            FontWeight.w600,
          ),
        ),
      ),
    );
  } */

  Widget nextButton(BuildContext context) {
    return CommonButton(
      text: getTranslate(APPStrings.textLetsCennec),
      onTap: () {
        if(getUser().hasInterests == true)
          {
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.routesScreenDashboard,(route) => false,);
          }
        else
          {
            Navigator.pushNamed(context, AppRoutes.routesScreenSignupInterests);
          }
      },
    );
  }

  Widget guideLines() {
    return SingleChildScrollView(
      child: Html(data: content.value),
    );
  }

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Dimens.margin10),
          logo(),
          const SizedBox(height: Dimens.margin30),
          communityGuidelinesTitle(context),
          const SizedBox(height: 20),
          Expanded(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    child: guideLines(),
                  ))),
          const SizedBox(height: Dimens.margin25),
          nextButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MultiValueListenableBuilder(
            valueListenables: [isLoading, content],
            builder: (context, values, child) {
              return BlocListener<GetCmsPageBloc, GetCmsPageState>(
                listener: (context, state) {
                  isLoading.value = state is GetCmsPageLoading;
                  if (state is GetCmsPageFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is GetCmsPageResponse) {
                    content.value = state.modelCms ?? '';
                  }
                },
                child: Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: Stack(
                    children: [getBody(context), Visibility(visible: isLoading.value, child: const Center(child: CommonLoadingAnimation()))],
                  ),
                ),
              );
            }));
  }

  void getPage() {
    BlocProvider.of<GetCmsPageBloc>(context).add(GetCmsPage(url: AppUrls.apiGetCmsContent(AppConfig.paramGuidelines)));
  }
}

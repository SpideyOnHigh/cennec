import 'package:cennec/modules/cms_pages/bloc/get_cms_page_bloc.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/infomation&guidelines/bloc/user_readed_about_us_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../core/utils/common_import.dart';

class ScreenAboutUs extends StatefulWidget {
  final bool isFromProfile;
  const ScreenAboutUs({super.key, required this.isFromProfile});

  @override
  State<ScreenAboutUs> createState() => _ScreenAboutUsState();
}

class _ScreenAboutUsState extends State<ScreenAboutUs> {
  @override
  void initState() {
    getPage();
    super.initState();
  }

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String> content = ValueNotifier('');

  Widget logo() {
    return Stack(
      children: [
        Visibility(
          visible: widget.isFromProfile,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(Dimens.margin16),
              child: Image.asset(
                APPImages.icBack,
                color: Theme.of(context).colorScheme.onSecondary, // Update with your logo path
                height: Dimens.margin30,
                width: Dimens.margin30,
              ),
            ),
          ),
        ),
        Center(
          child: Image.asset(
            APPImages.icLogoWithName, // Update with your logo path
            height: 100,
          ),
        ),
      ],
    );
  }

  Widget aboutUsText(BuildContext context) {
    return Text(
      getTranslate(APPStrings.textAboutUs).toString(),
      // textAlign: TextAlign.center,
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
           Navigator.pushNamed(context, AppRoutes.routesScreenCommunityGuidelines);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          getTranslate(APPStrings.textNextCG),
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
      text: getTranslate(APPStrings.textNextCG),
      onTap: () {
        postUserReaded();
      },
    );
  }

  Widget aboutUs() {
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
          Center(child: aboutUsText(context)),
          const SizedBox(height: 20),
          Expanded(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    child: aboutUs(),
                  ))),
          const SizedBox(height: Dimens.margin25),
          Visibility(visible: widget.isFromProfile == false, child: nextButton(context)),
          Visibility(visible: widget.isFromProfile == false, child: const SizedBox(height: 20)),
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
              return MultiBlocListener(
                listeners: [
                  BlocListener<GetCmsPageBloc, GetCmsPageState>(
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
                  ),
                  BlocListener<UserReadedAboutUsBloc, UserReadedAboutUsState>(
                    listener: (context, state) {
                      isLoading.value = state is UserReadedAboutUsLoading;
                      if (state is UserReadedAboutUsFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                      }
                      if(state is UserReadedAboutUsResponse)
                        {
                          PreferenceHelper.setBool(PreferenceHelper.hasReadAboutUs, true);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.routesScreenCommunityGuidelines,
                                (route) => false,
                          );
                        }
                    },
                  ),
                ],
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
    BlocProvider.of<GetCmsPageBloc>(context).add(GetCmsPage(url: AppUrls.apiGetCmsContent(AppConfig.paramAboutUs)));
  }

  void postUserReaded() {
    BlocProvider.of<UserReadedAboutUsBloc>(context).add(UserReadedAboutUs(url: AppUrls.apiPostUserAccepted(AppConfig.paramAboutUs)));
  }
}

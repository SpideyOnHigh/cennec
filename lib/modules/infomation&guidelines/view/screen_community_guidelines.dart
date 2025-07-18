import 'package:cennec/modules/cms_pages/bloc/get_cms_page_bloc.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/common_appbar.dart';
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
      height: 80,
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
        Dimens.margin24,
        AppColors.colorDarkBlue,
        FontWeight.w600,
      ),
    );
  }

  Widget nextButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: CommonButton(
        text: getTranslate(APPStrings.textLetsCennec),
        onTap: () {
          if(getUser().hasInterests == true) {
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.routesScreenDashboard,(route) => false,);
          } else {
            Navigator.pushNamed(context, AppRoutes.routesScreenSignupInterests);
          }
        },
      ),
    );
  }

  Widget guideLines() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Html(
        data: content.value,
        style: {
          "body": Style(
            fontFamily: AppFont.poppins,
            fontSize: FontSize(14),
            color: AppColors.colorDarkBlue,
            lineHeight: LineHeight(1.5),
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          ),
          "p": Style(
            margin: Margins.only(bottom: 16),
          ),
        },
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.colorDarkBlue,
          size: 24,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Community Guidelines',
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin18,
          AppColors.colorDarkBlue,
          FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget getBody(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Dimens.margin20),
        logo(),
        const SizedBox(height: Dimens.margin30),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                guideLines(),
                const SizedBox(height: Dimens.margin40),
              ],
            ),
          ),
        ),
        // Container(
        //   padding: const EdgeInsets.all(20),
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).scaffoldBackgroundColor,
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.grey.withOpacity(0.1),
        //         spreadRadius: 1,
        //         blurRadius: 5,
        //         offset: const Offset(0, -2),
        //       ),
        //     ],
        //   ),
        //   child: nextButton(context),
        // ),
      ],
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
              appBar: CommonAppBar( title: "Community Guidelines",),
              body: Stack(
                children: [
                  getBody(context),
                  Visibility(
                    visible: isLoading.value,
                    child: const Center(child: CommonLoadingAnimation()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void getPage() {
    BlocProvider.of<GetCmsPageBloc>(context).add(GetCmsPage(url: AppUrls.apiGetCmsContent(AppConfig.paramGuidelines)));
  }
}
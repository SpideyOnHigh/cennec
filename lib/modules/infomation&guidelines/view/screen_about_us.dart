import 'package:cennec/modules/cms_pages/bloc/get_cms_page_bloc.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/common_appbar.dart';
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



  Widget logoSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          children: [
            // Logo with circular background
            Container(
              width: 80,
              height: 80,

              child: Center(
                child: Image.asset(
                  APPImages.icLogoWithName,
                  fit: BoxFit.cover,
                  // height: 50,
                  // width: 50,
                ),
              ),
            ),
            // Version
            Text(
              "Beta Version 1.0.0.0",
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin14,
                Colors.grey,
                FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contentSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Default content if no CMS content is loaded
              if (content.value.isEmpty) ...[
                _buildDefaultContent(),
              ] else ...[
                Html(
                  data: content.value,
                  style: {
                    "body": Style(
                      fontSize: FontSize(14),
                      color: Colors.black87,
                      lineHeight: const LineHeight(1.5),
                      fontFamily: AppFont.poppins,
                    ),
                    "p": Style(
                      margin: Margins.only(bottom: 12),
                    ),
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Cennec is a space for clinicians, safe and authentic connection and communication.",
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin14,
            Colors.black87,
            FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Our goal is to use this space as a powerful tool for connection and communication. We appreciate your commitment to maintain integrity and respectfully. This will help both the help and support flow for communicating as well as features on the platform.",
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin14,
            Colors.black87,
            FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Since we are just getting started, we do not have all the features we desire to help just but with the help and support of the community, we can keep this platform safe, inclusive and authentic space.",
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin14,
            Colors.black87,
            FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "We are interested in building a community at this platform safe, inclusive and authentic space. We are not interested in any space features which users have been reported as blocked. These users who are consistently (3+) reported or blocked will be removed from the platform.",
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin14,
            Colors.black87,
            FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Since we are just getting started, we do not have all the features we desire to help but with the help and support of the community, we can keep this platform safe, inclusive and authentic space.",
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin14,
            Colors.black87,
            FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "We are not interested in any content or conversations that spammy or inappropriate. We will kick out such users. There are also users who are consistently (3+) reported or blocked will be removed from the platform.",
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin14,
            Colors.black87,
            FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "For any concerns, suggestions, questions, feedback, and queries with Cennec email us at",
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin14,
            Colors.black87,
            FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget bottomSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Terms & Conditions
          InkWell(
            onTap: () {
              // Navigate to Terms & Conditions
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Terms & Conditions",
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin16,
                    Colors.black,
                    FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Privacy Policy
          InkWell(
            onTap: () {
              // Navigate to Privacy Policy
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Privacy Policy",
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin16,
                    Colors.black,
                    FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Next button (only show if not from profile)
          Visibility(
            visible: widget.isFromProfile == false,
            child: SizedBox(
              width: double.infinity,
              child: CommonButton(
                text: getTranslate(APPStrings.textNextCG),
                onTap: () {
                  postUserReaded();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
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
                if (state is UserReadedAboutUsResponse) {
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
            // backgroundColor: AppColors.s,
            appBar: CommonAppBar(title: "About Us",),
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      // customAppBar(),
                      logoSection(),
                      contentSection(),
                      bottomSection(),
                    ],
                  ),
                  Visibility(
                    visible: isLoading.value,
                    child: const Center(child: CommonLoadingAnimation()),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void getPage() {
    BlocProvider.of<GetCmsPageBloc>(context).add(GetCmsPage(url: AppUrls.apiGetCmsContent(AppConfig.paramAboutUs)));
  }

  void postUserReaded() {
    BlocProvider.of<UserReadedAboutUsBloc>(context).add(UserReadedAboutUs(url: AppUrls.apiPostUserAccepted(AppConfig.paramAboutUs)));
  }
}
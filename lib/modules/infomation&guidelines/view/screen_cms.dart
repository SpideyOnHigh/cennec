import 'package:cennec/modules/cms_pages/bloc/get_cms_page_bloc.dart';
import 'package:cennec/modules/cms_pages/repository/repository_cms.dart';
import 'package:cennec/modules/core/common/widgets/common_appbar.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart';

import '../../core/utils/common_import.dart';

enum CmsPageType { termsConditions, privacyPolicy }

class ScreenCmsPage extends StatefulWidget {
  final CmsPageType pageType;

  const ScreenCmsPage({
    super.key,
    required this.pageType,
  });

  @override
  State<ScreenCmsPage> createState() => _ScreenCmsPageState();
}

class _ScreenCmsPageState extends State<ScreenCmsPage> {
  late GetCmsPageBloc _cmsBloc;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String> content = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    // Create a completely new bloc instance with proper dependencies
    _cmsBloc = GetCmsPageBloc(
      // You need to pass the required dependencies here
      // Example (adjust based on your actual constructor):
      repositoryGetCmsPage: RepositoryGetCmsPage(), // or however you get this
      apiProvider: ApiProvider(), // or however you get this
      client: Client(), // or however you get this
    );
    getPage();
  }

  @override
  void dispose() {
    _cmsBloc.close(); // Properly dispose the bloc
    super.dispose();
  }

  String get pageTitle {
    switch (widget.pageType) {
      case CmsPageType.termsConditions:
        return "Terms & Conditions";
      case CmsPageType.privacyPolicy:
        return "Privacy Policy";
    }
  }

  String get apiSlug {
    switch (widget.pageType) {
      case CmsPageType.termsConditions:
        return "terms-conditions";
      case CmsPageType.privacyPolicy:
        return "privacy-policy";
    }
  }

  Widget logoSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              child: Center(
                child: Image.asset(
                  APPImages.icLogoWithName,
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
              if (content.value.isEmpty) ...[
                // _buildDefaultContent(),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultContent() {
    String defaultText;

    switch (widget.pageType) {
      case CmsPageType.termsConditions:
        defaultText = "Loading Terms & Conditions content...";
        break;
      case CmsPageType.privacyPolicy:
        defaultText = "Loading Privacy Policy content...";
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          defaultText,
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin14,
            Colors.black87,
            FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Please wait while we load the content from our servers.",
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin14,
            Colors.grey,
            FontWeight.w400,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cmsBloc, // Use our specific bloc instance
      child: ValueListenableBuilder(
        valueListenable: content,
        builder: (context, contentValue, child) {
          return ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (context, loading, child) {
              return BlocListener<GetCmsPageBloc, GetCmsPageState>(
                bloc: _cmsBloc, // Listen to our specific bloc
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
                  appBar: CommonAppBar(title: pageTitle),
                  body: SafeArea(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            // logoSection(),
                            contentSection(),
                          ],
                        ),
                        Visibility(
                          visible: loading,
                          child: const Center(child: CommonLoadingAnimation()),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void getPage() {
    _cmsBloc.add(GetCmsPage(url: AppUrls.apiGetCmsContent(apiSlug)));
  }
}
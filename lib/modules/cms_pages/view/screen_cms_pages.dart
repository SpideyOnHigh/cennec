import 'package:cennec/modules/cms_pages/bloc/get_cms_page_bloc.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:flutter_html/flutter_html.dart';

class ScreenHtmlContent extends StatefulWidget {
  final String slug;
  const ScreenHtmlContent({super.key, required this.slug});

  @override
  State<ScreenHtmlContent> createState() => _ScreenHtmlContentState();
}

class _ScreenHtmlContentState extends State<ScreenHtmlContent> {

  @override
  void initState() {
    getPage();
    super.initState();
  }

  Widget navigationWithLogo() {
    return Stack(
      children: [
        InkWell(
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
        Center(
          child: Image.asset(
            APPImages.icLogoWithName, // Update with your logo path
            height: 80,
          ),
        ),
      ],
    );
  }

  ValueNotifier<String> content = ValueNotifier('');
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Widget getBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: Dimens.margin10,
        ),
        navigationWithLogo(),
        Expanded(
          child: SingleChildScrollView(
            child: Html(data: content.value),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MultiValueListenableBuilder(
            valueListenables: [isLoading,content
            ],
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
                    children: [
                      getBody(),
                      Visibility(
                          visible: isLoading.value,
                          child: const Center(child: CommonLoadingAnimation()))
                    ],
                  ),
                ),
              );
            }));
  }

  void getPage()  {
    BlocProvider.of<GetCmsPageBloc>(context).add(GetCmsPage(url: AppUrls.apiGetCmsContent(widget.slug)));
  }
}

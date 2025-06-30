import 'package:cennec/modules/connections/bloc/fetch_user_bloc/fetch_user_details_bloc.dart';
import 'package:cennec/modules/connections/model/model_fetch_user_detail.dart';
import 'package:cennec/modules/connections/model/model_send_request.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/core/utils/common_import.dart';

class ScreenFavourites extends StatefulWidget {
  final ModelRequestDataTransfer modelRequestDataTransfer;

  const ScreenFavourites({super.key, required this.modelRequestDataTransfer});

  @override
  State<ScreenFavourites> createState() => _ScreenFavouritesState();
}

class _ScreenFavouritesState extends State<ScreenFavourites> {
  bool isAdded = false;

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ModelFetchUserDetail modelFetchUserDetail = ModelFetchUserDetail();

  @override
  void initState() {
    fetchDetail();
    super.initState();
  }

  Widget navigationWithLogo() {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: Image.asset(
            APPImages.icBack,
            color: Theme.of(context)
                .colorScheme
                .onSecondary, // Update with your logo path
            height: Dimens.margin30,
            width: Dimens.margin30,
          ),
        ),
        Center(
          child: Image.asset(
            APPImages.icCennecBottom, // Update with your logo path
            height: 40,
          ),
        ),
      ],
    );
  }

  Widget favoritesTitle(BuildContext context) {
    return Center(
      child: Text(
        textAlign: TextAlign.center,
        // getTranslate(APPStrings.textSelectInterests).toString(),
        "You Favorited ${modelFetchUserDetail.data?.username ?? ''}!",
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin32,
          Theme.of(context).colorScheme.onPrimary,
          FontWeight.w600,
        ),
      ),
    );
  }

  Widget mutualInterestsText() {
    return Text(
      // getTranslate(APPStrings.textSelectInterests).toString(),
      "${(modelFetchUserDetail.data?.mutualInterests ?? []).length} ${getTranslate(APPStrings.textMutualInts)}",
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin20,
        Theme.of(context).colorScheme.onPrimary,
        FontWeight.w600,
      ),
    );
  }

  Widget interestGridview() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: Dimens.margin5,
        children: [
          ...List.generate(
            (modelFetchUserDetail.data?.mutualInterests ?? []).length,
            (index) => GestureDetector(
              onTap: () {
                /*   setState(() {
                  interests[index].isSelected = !interests[index].isSelected;
                  interests[index].color = getRandomColor();
                });*/
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimens.margin11),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.3,
                    ),
                    color: hexToColor(modelFetchUserDetail
                            .data?.mutualInterests?[index].interestColor ??
                        ''),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(Dimens.margin8),
                  child: Text(
                    modelFetchUserDetail
                            .data?.mutualInterests?[index].interestName ??
                        '',
                    style: getTextStyleFromFont(
                      AppFont.poppins,
                      Dimens.margin18,
                      Theme.of(context).colorScheme.onSecondary,
                      FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget cennectionHorizontalGridview() {
    return Center(
      child: Container(
        width: Dimens.margin210,
        height: Dimens.margin210,
        decoration: BoxDecoration(
            // image: const DecorationImage(
            //     image: AssetImage(APPImages.icDummyProfile), fit: BoxFit.cover),
            // color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(Dimens.margin30)),
        child: (modelFetchUserDetail.data?.profileImages ?? []).isNotEmpty &&
                modelFetchUserDetail.data?.profileImages != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.margin30),
                child: Image.network(
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Image is fully loaded
                    }
                    return const Center(
                      child:
                          CommonLoadingAnimation(), // Show the loading animation
                    );
                  },
                  modelFetchUserDetail.data?.profileImages?.first.imageUrl ??
                      '',
                  width: Dimens.margin225,
                  height: Dimens.margin300,
                  fit: BoxFit.cover,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.margin30),
                child: SizedBox(
                  height: 300,
                  width: 225,
                  child: Image.asset(
                    APPImages.icDummyProfile,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ),
    );
  }

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: Dimens.margin20),
              navigationWithLogo(),
              const SizedBox(height: Dimens.margin40),
              favoritesTitle(context),
              const SizedBox(height: Dimens.margin15),
              cennectionHorizontalGridview(),
              const SizedBox(height: Dimens.margin20),
              mutualInterestsText(),
              const SizedBox(height: Dimens.margin20),
              interestGridview()
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [isLoading],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<FetchUserDetailsBloc, FetchUserDetailsState>(
                listener: (context, state) {
                  isLoading.value = state is FetchUserDetailsLoading;
                  if (state is FetchUserDetailsFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context,
                          state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is FetchUserDetailsResponse) {
                    modelFetchUserDetail = state.modelFetchUserDetail;
                  }
                },
              ),
            ],
            child: SafeArea(
                child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Stack(
                children: [
                  IgnorePointer(
                      ignoring: isLoading.value, child: getBody(context)),
                  Visibility(
                      visible: isLoading.value,
                      child: const Center(child: CommonLoadingAnimation()))
                ],
              ),
            )),
          );
        });
  }

  void fetchDetail() {
    BlocProvider.of<FetchUserDetailsBloc>(context).add(FetchUserDetails(
        url: AppUrls.apiFetchUserDetails(
            widget.modelRequestDataTransfer.toSendUserID ?? 0)));
  }
}

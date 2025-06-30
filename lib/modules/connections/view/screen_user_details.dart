import 'package:cennec/modules/connections/bloc/add_to_favourite/favourites_bloc.dart';
import 'package:cennec/modules/connections/bloc/delete_connection/delete_connection_bloc.dart';
import 'package:cennec/modules/connections/bloc/fetch_user_bloc/fetch_user_details_bloc.dart';
import 'package:cennec/modules/connections/bloc/removeFromFavourite/remove_from_favourite_bloc.dart';
import 'package:cennec/modules/connections/bloc/remove_user_from_details/remove_user_from_details_bloc.dart';
import 'package:cennec/modules/connections/model/model_fetch_user_detail.dart';
import 'package:cennec/modules/connections/model/model_recommendations.dart';
import 'package:cennec/modules/connections/model/model_send_request.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/dialog/cupertino_confirmation_dialog.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:cennec/modules/interests/model/model_interests.dart';
import 'package:cennec/modules/interests/model/navigation_back_handling_model.dart';
import 'package:cennec/modules/preferences/bloc/block_user/block_user_bloc.dart';
import 'package:cennec/modules/preferences/bloc/report_user/report_user_bloc.dart';
import 'package:cennec/modules/profile/widgets/custom_progress_bar.dart';
import 'package:flutter/cupertino.dart';

import '../../chat/models/MessageRoomRequestData.dart';

class ScreenUserDetails extends StatefulWidget {
  final ModelRequestDataTransfer modelRequestDataTransfer;
  const ScreenUserDetails({super.key, required this.modelRequestDataTransfer});

  @override
  State<ScreenUserDetails> createState() => _ScreenUserDetailsState();
}

class _ScreenUserDetailsState extends State<ScreenUserDetails> {
  @override
  void initState() {
    fetchDetail();
    super.initState();
  }

  ValueNotifier<int> pageIndex = ValueNotifier(0);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isUpdating = ValueNotifier(false);
  ModelFetchUserDetail modelFetchUserDetail = ModelFetchUserDetail();
  ModelNavigationBackHandling modelNavigationBackHandling = ModelNavigationBackHandling();

  Widget myProfileTexts(BuildContext context) {
    return Row(
      children: [
        Text(
          getTranslate(APPStrings.textAbout),
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin25,
            Theme.of(context).hintColor,
            FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget myAnswers(BuildContext context) {
    return Row(
      children: [
        Text(
          getTranslate(APPStrings.textAnswers),
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin25,
            Theme.of(context).hintColor,
            FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget mutualInterestsTexts(BuildContext context) {
    return Row(
      children: [
        Text(
          getTranslate(APPStrings.textMutualInts),
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin25,
            Theme.of(context).hintColor,
            FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget navigationWithLogo() {
    return InkWell(
      // onTap: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.maxFinite,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context, modelNavigationBackHandling),
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(Dimens.margin50)),
                  height: Dimens.margin45,
                  width: Dimens.margin45,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Image.asset(APPImages.icBack),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        if (modelFetchUserDetail.data?.isFavourite ?? false) {
                          removeFromFavourite(widget.modelRequestDataTransfer.getUserId ?? 0);
                        } else {
                          addToFavourite(widget.modelRequestDataTransfer.getUserId ?? 0);
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.margin100), color: Theme.of(context).colorScheme.primary),
                          height: Dimens.margin40,
                          width: Dimens.margin40,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              APPImages.icStarPng,
                              color: (modelFetchUserDetail.data?.isFavourite ?? false) ? Colors.white : Colors.grey,
                            ),
                          )),
                    ),
                    const SizedBox(
                      width: Dimens.margin20,
                    ),
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      offset: const Offset(0, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoConfirmationDialog(
                                title: getTranslate(APPStrings.textReportUser),
                                description: getTranslate(APPStrings.textReportCnf),
                                cancelText: getTranslate(APPStrings.textCancel),
                                confirmText: getTranslate(APPStrings.textOk),
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                                onConfirm: () {
                                  printWrapped("pressed key");
                                  reportUser(modelFetchUserDetail.data?.id ?? 0);
                                  // Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                          value: 'report',
                          child: Text(getTranslate(APPStrings.textReportUser)),
                        ),
                        PopupMenuItem<String>(
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoConfirmationDialog(
                                title: getTranslate(APPStrings.textBlockUser),
                                description: getTranslate(APPStrings.textBlockCnf),
                                cancelText: getTranslate(APPStrings.textCancel),
                                confirmText: getTranslate(APPStrings.textOk),
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                                onConfirm: () {
                                  blockUser(modelFetchUserDetail.data?.id ?? 0);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                          value: 'block',
                          child: Text(getTranslate(APPStrings.textBlockUser)),
                        ),
                      ],
                      child: Container(
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(Dimens.margin50), color: Theme.of(context).primaryColor.withOpacity(0.7)),
                          height: Dimens.margin40,
                          width: Dimens.margin40,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              APPImages.icPopUp,
                              color: /*dummyName.value[index].isFavourite ? Colors.deepOrangeAccent : */ Colors.grey,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textWidget(String text) {
    return Text(
      text,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin20,
        Theme.of(context).colorScheme.onPrimary,
        FontWeight.w600,
      ),
    );
  }

  Widget interestGridview() {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: Dimens.margin5,
      children: [
        ...List.generate(
          (modelFetchUserDetail.data?.mutualInterests ?? []).length,
          (index) => GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.routesScreenRecommendationOfInterests,
                  arguments: ModelInterestsDataTransfer(interestId: modelFetchUserDetail.data?.mutualInterests?[index].id, interestName: modelFetchUserDetail.data?.mutualInterests?[index].interestName)).then(
                    (value) {
                  if(value == true)
                  {
                    fetchDetail();
                  }
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.margin11),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.3,
                  ),
                  color: hexToColor(modelFetchUserDetail.data?.mutualInterests?[index].interestColor ?? ''),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(Dimens.margin8),
                child: Text(
                  modelFetchUserDetail.data?.mutualInterests?[index].interestName ?? '',
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin18,
                    Theme.of(context).colorScheme.primary,
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget userPreferences(QuestionsWithAnswers data)
  {
    return Material(
      color: Colors.transparent,
      elevation: 5,
      borderRadius: BorderRadius.circular(Dimens.margin20),
      child: Container(
        // height: Dimens.margin100,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimens.margin20)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.question ?? '',
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin17,
                  Theme.of(context).colorScheme.onSecondary,
                  FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: Dimens.margin10,
              ),
              Text(
                data.answer ?? '',
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin25,
                  Theme.of(context).colorScheme.onPrimary,
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabOne() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: myProfileTexts(context),
            ),
            const SizedBox(
              height: Dimens.margin10,
            ),
            textWidget(modelFetchUserDetail.data?.bio ?? getTranslate(APPStrings.textNoBio)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: mutualInterestsTexts(context),
            ),
            interestGridview()
          ],
        ),
      ),
    );
  }

  Widget tabTwo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: myAnswers(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: (modelFetchUserDetail.data?.questionAnswersList ?? []).length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: userPreferences(modelFetchUserDetail.data?.questionAnswersList?[index] ?? QuestionsWithAnswers()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget userNameAndconnection() {
    return SizedBox(
      height: Dimens.margin200,
      child: Column(
        children: [
          Text(
            modelFetchUserDetail.data?.username ?? '',
            style: getTextStyleFromFont(
              shadow: <Shadow>[
                const Shadow(
                  // offset: Offset(5.0, 5.0),
                  blurRadius: Dimens.margin25,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
              AppFont.poppins,
              Dimens.margin35,
              Theme.of(context).primaryColor,
              FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: Dimens.margin20,
          ),
          SizedBox(
            width: Dimens.margin120,
            child: Row(
              mainAxisAlignment: modelFetchUserDetail.data?.isSentRequest == true ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      if(modelFetchUserDetail.data?.isConnected == true) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) =>
                              CupertinoConfirmationDialog(
                                title: getTranslate(APPStrings.textDeleteConnection),
                                description: getTranslate(APPStrings.textDeleteCnf),
                                cancelText: getTranslate(APPStrings.textCancel),
                                confirmText: getTranslate(APPStrings.textOk),
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                                onConfirm: () {
                                  deleteConnection(modelFetchUserDetail.data?.id ?? 0);
                                  Navigator.pop(context);
                                },
                              ),
                        );
                      }
                      else
                        {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoConfirmationDialog(
                              title: "Remove User",
                              description: "Are you sure you want to remove this user?",
                              cancelText: "Cancel",
                              confirmText: "OK",
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              onConfirm: () {
                                printWrapped("pressed key");
                                Navigator.pop(context);
                                removeUserFromDetails(widget.modelRequestDataTransfer.getUserId ?? 0);
                              },
                            ),
                          );
                        }
                    },
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.margin100), color: Theme.of(context).colorScheme.primary),
                        height: Dimens.margin55,
                        width: Dimens.margin55,
                        child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              APPImages.icCrossTsp,
                              color: Colors.white,
                            )))),
                Visibility(
                  visible: modelFetchUserDetail.data?.isSentRequest == false,
                  child: InkWell(
                    onTap: () {
                      if(modelFetchUserDetail.data?.isConnected == true){
                        Navigator.pushNamed(context, AppRoutes.routesScreenChats,arguments: MessageRoomRequestData(fromUserId: widget.modelRequestDataTransfer.getUserId!, page: 1,name: modelFetchUserDetail.data?.username ?? '',
                            imageUrl:modelFetchUserDetail.data?.defaultProfilePic ??  ''));

                      } else{
                        Navigator.pushNamed(context, AppRoutes.routesScreenSendRequest,
                            arguments: ModelRequestDataTransfer(toSendUserID: widget.modelRequestDataTransfer.getUserId))
                            .then(
                              (value) {
                            if (value != null) {
                              fetchDetail();
                            }
                          },
                        );

                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimens.margin100),
                            color: modelFetchUserDetail.data?.isConnected == true ? Theme.of(context).hintColor : null),
                        height: Dimens.margin55,
                        width: Dimens.margin55,
                        child: Padding(
                          padding: EdgeInsets.all(modelFetchUserDetail.data?.isConnected == true ? 10.0 : 0),
                          child: Image.asset(
                            modelFetchUserDetail.data?.isConnected == true ? APPImages.icBottomMsg : APPImages.icCennecButton,
                            color: modelFetchUserDetail.data?.isConnected == true ? Colors.white : null,
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget images(ProfileImages data)
  {
    return Image.network(
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child; // Image is fully loaded
        }
        return const Center(
          child: CommonLoadingAnimation(), // Show the loading animation
        );
      },
      data.imageUrl ?? '',
      width: double.maxFinite,
      height: 200,
      fit: BoxFit.cover,
    );
  }


  Widget getBody() {
    return Stack(
      children: [
        SizedBox(
          height:  MediaQuery.of(context).size.height / 1.7,
          child: Visibility(
            visible: (modelFetchUserDetail.data?.profileImages ?? []).isNotEmpty,
            replacement: Image.asset(
              APPImages.icDummyProfile, // Replace with your actual image path
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 1.7,
            ),
            child: PageView.custom(
              allowImplicitScrolling: false,
              onPageChanged: (value) {
                // pageIndex.value = value;
              },
              childrenDelegate: SliverChildListDelegate(
                List.generate((modelFetchUserDetail.data?.profileImages ?? []).length, (index) {
                  return SizedBox(
                      child: images(modelFetchUserDetail.data?.profileImages?[index] ?? ProfileImages()));
                },),
              ),
            ),
          ),
        ),
        SafeArea(child: navigationWithLogo()),
        // Positioned(
        //     left: 20,
        //     top: 80,
        //     child: navigationWithLogo()),
        // Content
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              userNameAndconnection(),
              Container(
                height: Dimens.margin400,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimens.margin30), topRight: Radius.circular(Dimens.margin30)),
                    color: Theme.of(context).primaryColor),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: Dimens.margin200,
                        child: CustomProgressBar(
                          totalSteps: 2,
                          currentSteps: pageIndex.value + 1,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.margin10,
                    ),
                    Expanded(
                      child: PageView.custom(
                        onPageChanged: (value) {
                          pageIndex.value = value;
                        },
                        childrenDelegate: SliverChildListDelegate(
                          [tabOne(), tabTwo()],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Bottom Navigation Bar
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [isLoading, pageIndex],
        builder: (context, values, child) {
          return MultiBlocListener(
            listeners: [
              BlocListener<FetchUserDetailsBloc, FetchUserDetailsState>(
                listener: (context, state) {
                  isLoading.value = state is FetchUserDetailsLoading;
                  if (state is FetchUserDetailsFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is FetchUserDetailsResponse) {
                    modelFetchUserDetail = state.modelFetchUserDetail;
                    modelNavigationBackHandling = ModelNavigationBackHandling(
                      isConnected: state.modelFetchUserDetail.data?.isConnected ?? false,
                      isFavourite: state.modelFetchUserDetail.data?.isFavourite ?? false,
                      isRemoved: false,
                    );
                  }
                },
              ),
              BlocListener<BlockUserBloc, BlockUserState>(
                listener: (context, state) {
                  isLoading.value = state is BlockUserLoading;
                  if (state is BlockUserFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is BlockUserResponse) {
                    modelNavigationBackHandling.isRemoved = true;
                    Navigator.pop(context, modelNavigationBackHandling);
                    ToastController.showToast(context, state.modelBlockResponse.message ?? '', true);
                    // modelFetchUserDetail = state.modelFetchUserDetail;
                  }
                },
              ),
              BlocListener<ReportUserBloc, ReportUserState>(
                listener: (context, state) {
                  isLoading.value = state is ReportUserLoading;
                  if (state is ReportUserFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is ReportUserResponse) {
                    ToastController.showToast(context, state.modelReport.message ?? '', true);
                    Navigator.pop(context, modelNavigationBackHandling);
                    // modelFetchUserDetail = state.modelFetchUserDetail;
                  }
                },
              ),
              BlocListener<DeleteConnectionBloc, DeleteConnectionState>(
                listener: (context, state) {
                  isLoading.value = state is DeleteConnectionLoading;
                  if (state is DeleteConnectionFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is DeleteConnectionResponse) {
                    ToastController.showToast(context, state.modelSuccess.message ?? '', true);
                    modelNavigationBackHandling.isConnected = false;
                    Navigator.pop(context, modelNavigationBackHandling);
                    // modelFetchUserDetail = state.modelFetchUserDetail;
                  }
                },
              ),
              BlocListener<FavouritesBloc, FavouritesState>(
                listener: (context, state) {
                  isLoading.value = state is FavouritesLoading;
                  if (state is FavouritesFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is FavouritesResponse) {
                    // here navigation is handled by previous screen bloc as it is in context will update later when time will be available
                    if (widget.modelRequestDataTransfer.isFromDashboard == true) {
                      modelNavigationBackHandling.isFavourite = true;
                      Navigator.pushNamed(context, AppRoutes.routesScreenFavourite,
                              arguments: ModelRequestDataTransfer(toSendUserID: widget.modelRequestDataTransfer.getUserId))
                          .then(
                        (value) {
                          if (value != null && value == true) {
                            // getRecommendations();
                          }
                        },
                      );
                    }
                  }
                },
              ),
              BlocListener<RemoveFromFavouriteBloc, RemoveFromFavouriteState>(
                listener: (context, state) {
                  isLoading.value = state is RemoveFromFavouriteLoading;
                  if (state is RemoveFromFavouriteFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is RemoveFromFavouriteResponse) {
                    modelFetchUserDetail.data?.isFavourite = false;
                    modelNavigationBackHandling.isFavourite = false;
                    ToastController.showToast(context, state.modelSuccess.message ?? '', true);
                  }
                },
              ),
              BlocListener<RemoveUserFromDetailsBloc, RemoveUserFromDetailsState>(
                listener: (context, state) {
                  isLoading.value = state is RemoveUserFromDetailsLoading;
                  if (state is RemoveUserFromDetailsFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                  }
                  if (state is RemoveUserFromDetailsResponse) {
                    ToastController.showToast(context, state.modelSuccess.message ?? '', true);
                    modelNavigationBackHandling.isRemoved = true;
                    Navigator.pop(context,modelNavigationBackHandling);
                    // getRecommendations();
                  }
                },
              ),
            ],
            child: Scaffold(
                          resizeToAvoidBottomInset: true,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          body: Stack(
            children: [
              IgnorePointer(ignoring: isLoading.value, child: getBody()),
              Visibility(visible: isLoading.value, child: const Center(child: CommonLoadingAnimation()))
            ],
                          ),
                        ),
          );
        });
  }

  void fetchDetail() {
    BlocProvider.of<FetchUserDetailsBloc>(context).add(FetchUserDetails(url: AppUrls.apiFetchUserDetails(widget.modelRequestDataTransfer.getUserId ?? 0)));
  }

  void addToFavourite(int toUserId) {
    Map<String, dynamic> body = {
      AppConfig.paramFavouriteBy: getUser().userData?.id ?? 0,
      AppConfig.paramFavouriteTo: toUserId,
    };

    BlocProvider.of<FavouritesBloc>(context).add(AddToFavourites(url: AppUrls.apiAddToFavourites, body: body));
  }

  void blockUser(int toUserId) {
    Map<String, dynamic> body = {
      AppConfig.paramBlockedBy: getUser().userData?.id ?? 0,
      AppConfig.paramBlockedTo: toUserId,
    };

    BlocProvider.of<BlockUserBloc>(context).add(BlockUser(url: AppUrls.apiBlockUser, body: body));
  }

  void reportUser(int toUserId) {
    Map<String, dynamic> body = {
      AppConfig.paramReportBy: getUser().userData?.id ?? 0,
      AppConfig.paramReportTo: toUserId,
    };

    BlocProvider.of<ReportUserBloc>(context).add(ReportUser(url: AppUrls.apiReportUser, body: body));
  }

  void deleteConnection(int friendId) {
    BlocProvider.of<DeleteConnectionBloc>(context).add(DeleteConnection(url: AppUrls.apiDeleteConnection(friendId)));
  }

  void removeFromFavourite(int friendId) {
    BlocProvider.of<RemoveFromFavouriteBloc>(context).add(RemoveFromFavourite(url: AppUrls.apiRemoveFavourite(friendId)));
  }
  void removeUserFromDetails(int userId) {
    BlocProvider.of<RemoveUserFromDetailsBloc>(context).add(RemoveUserFromDetails(url: AppUrls.apiRemoveUser(userId)));
  }
}

import 'package:cennec/modules/connections/bloc/add_to_favourite/favourites_bloc.dart';
import 'package:cennec/modules/connections/bloc/removeFromFavourite/remove_from_favourite_bloc.dart';
import 'package:cennec/modules/connections/bloc/remove_user/remove_user_bloc.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/interests/bloc/add_remove_interests/add_remove_interests_bloc.dart';
import 'package:cennec/modules/interests/bloc/get_interests_recommendation/recommendations_of_interest_bloc.dart';
import 'package:cennec/modules/interests/model/model_interests.dart';
import 'package:cennec/modules/interests/model/model_recommendations_of_interests.dart';
import 'package:cennec/modules/interests/model/navigation_back_handling_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../connections/model/model_send_request.dart';
import '../../core/common/widgets/button.dart';
import '../../core/common/widgets/dialog/cupertino_confirmation_dialog.dart';
import '../../core/utils/common_import.dart';

class ScreenRecommendationOfInterests extends StatefulWidget {
  final ModelInterestsDataTransfer modelInterestsDataTransfer;
  const ScreenRecommendationOfInterests({super.key, required this.modelInterestsDataTransfer});

  @override
  State<ScreenRecommendationOfInterests> createState() => _ScreenRecommendationOfInterestsState();
}

class _ScreenRecommendationOfInterestsState extends State<ScreenRecommendationOfInterests> {
  bool isAdded = false;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isUpdating = ValueNotifier(false);
  ValueNotifier<bool> paginationLoading = ValueNotifier(false);
  ValueNotifier<bool> showLoadMore = ValueNotifier(false);
  ValueNotifier<ModelRecommendationsOfInterest> modelRecommendations = ValueNotifier(ModelRecommendationsOfInterest());
  ValueNotifier<List<RecommendationsList>> recommendationsList = ValueNotifier([]);
  int? selectedUserId;
  int? selectedIndex;
  int? updatedRelatedInterest;
  int pageNumber = 1;
  int perPage = 20;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    getRecommendations(id: widget.modelInterestsDataTransfer.interestId ?? 0);
    updatedRelatedInterest = widget.modelInterestsDataTransfer.interestId ?? 0;
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
            color: Theme.of(context).colorScheme.onSecondary, // Update with your logo path
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

  Widget interestsTitle(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        // getTranslate(APPStrings.textSelectInterests).toString(),
        widget.modelInterestsDataTransfer.interestName ?? '',
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin32,
          Theme.of(context).hintColor,
          FontWeight.w600,
        ),
      ),
    );
  }

  Widget cennectionWithThisText() {
    return Text(
      getTranslate(APPStrings.textCennectionWithInterests).toString(),
      // "cennections with this interests",
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin20,
        Theme.of(context).hintColor,
        FontWeight.w600,
      ),
    );
  }

  Widget addOrRemoveButton() {
    return CommonButton(
      isLoading: isUpdating.value,
      text: getTranslate(modelRecommendations.value.interestExists == false ? APPStrings.textAddToInts : APPStrings.textRemoveFromInts),
      backgroundColor: Theme.of(context).colorScheme.primary,
      onTap: () {
        addRemoveInts();

        // setState(() {
        //   modelRecommendations.value.interestExists == true ? modelRecommendations.value.interestExists = false :
        //   modelRecommendations.value.interestExists = true;
        //   addRemoveInts();
        // });
      },
    );
  }

  Widget relatedInterestsText() {
    return Text(
      getTranslate(APPStrings.textRelatedInterests).toString(),
      // "related interests",
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin20,
        Theme.of(context).hintColor,
        FontWeight.w600,
      ),
    );
  }

  final List<Interest> interests = [
    Interest(name: 'Interior design'),
    Interest(name: 'Economics'),
    Interest(name: 'Engineering'),
    Interest(name: 'Entrepreneurship'),
    Interest(name: 'Health care'),
    Interest(name: 'Higher education'),
  ];

  Widget interestGridview() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: Dimens.margin5,
        children: [
          ...List.generate(
            (modelRecommendations.value.relatedInterest ?? []).length,
            (index) => GestureDetector(
              onTap: () {
                updatedRelatedInterest = modelRecommendations.value.relatedInterest?[index].id;
                widget.modelInterestsDataTransfer.interestName = modelRecommendations.value.relatedInterest?[index].interestName;
                pageNumber = 1;
                getRecommendations(id: updatedRelatedInterest ?? 0);
                // setState(() {
                //   interests[index].isSelected = !interests[index].isSelected;
                //   interests[index].color = getRandomColor();
                // });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimens.margin11),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.3,
                    ),
                    color: modelRecommendations.value.relatedInterest?[index].isInterestedAdded == true
                        ? hexToColor(modelRecommendations.value.relatedInterest?[index].interestColor ?? '')
                        : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(Dimens.margin8),
                  child: Text(
                    modelRecommendations.value.relatedInterest?[index].interestName ?? '',
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
    return SizedBox(
      height: 300,
      child: Visibility(
        visible: recommendationsList.value.isNotEmpty,
        replacement: Center(
            child: Text(
          getTranslate(APPStrings.textNoConnections),
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin18,
            Theme.of(context).hintColor.withOpacity(0.9),
            FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5) ?? FontWeight.w500,
          ),
        )),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recommendationsList.value.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        selectedUserId = recommendationsList.value[index].userId;
                        selectedIndex = index;
                        Navigator.pushNamed(context, AppRoutes.routesScreenUserDetails,
                                arguments: ModelRequestDataTransfer(getUserId: recommendationsList.value[index].userId))
                            .then(
                          (value) {
                            if (value != null) {
                              ModelNavigationBackHandling model = value as ModelNavigationBackHandling;
                              printWrapped("model data = ${model.isFavourite}");
                              printWrapped("selected Index = $selectedIndex");
                              setState(() {
                                if (model.isFavourite != null) {
                                  recommendationsList.value[selectedIndex ?? 0].isFavourite = model.isFavourite;
                                }
                                if (model.isRemoved != null && model.isRemoved == true) {
                                  recommendationsList.value.removeAt(selectedIndex ?? 0);
                                }
                                if(model.isConnected != null)
                                  {
                                    recommendationsList.value[selectedIndex ?? 0].isConnected = model.isConnected;
                                  }
                              });
                              // printWrapped("refreshed");
                              // printWrapped("page nuimber = $pageNumber");
                              // getRecommendations(
                              //     id: updatedRelatedInterest ?? 0,
                              // );
                            }
                          },
                        );
                      },
                      child: Container(
                        width: Dimens.margin225,
                        decoration: BoxDecoration(
                            // image: const DecorationImage(image: AssetImage(APPImages.icDummyProfile), fit: BoxFit.cover),
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(Dimens.margin30)),
                        child: Stack(
                          // fit: StackFit.,
                          children: [
                            (recommendationsList.value[index].profileImages ?? []).isNotEmpty && recommendationsList.value[index].profileImages != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimens.margin30),
                                    child: Image.network(
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child; // Image is fully loaded
                                        }
                                        return const Center(
                                          child: CommonLoadingAnimation(), // Show the loading animation
                                        );
                                      },
                                      recommendationsList.value[index].defaultProfilePic ?? '',
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // InkWell(
                                    //   onTap: () {
                                    //     showCupertinoDialog(
                                    //       context: context,
                                    //       builder: (context) => CupertinoConfirmationDialog(
                                    //         title: "Report User",
                                    //         description: "Are you sure you want to report this user?",
                                    //         cancelText: "Cancel",
                                    //         confirmText: "OK",
                                    //         onCancel: () {
                                    //           Navigator.pop(context);
                                    //         },
                                    //         onConfirm: () {
                                    //           printWrapped("pressed key");
                                    //           Navigator.pop(context);
                                    //         },
                                    //       ),
                                    //     );
                                    //   },
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(10.0),
                                    //     child: SizedBox(height: Dimens.margin40, width: Dimens.margin40, child: SvgPicture.asset(APPImages.icFlagSvg)),
                                    //   ),
                                    // ),
                                    InkWell(
                                      onTap: () {
                                        // setState(() {
                                        //   // dummyName.value[index].isFavourite = !dummyName.value[index].isFavourite;
                                        // });
                                        selectedUserId = recommendationsList.value[index].userId;
                                        selectedIndex = index;
                                        if (recommendationsList.value[index].isFavourite ?? false) {
                                          removeFromFavourite(recommendationsList.value[index].userId ?? 0);
                                        } else {
                                          addToFavourite(recommendationsList.value[index].userId ?? 0);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(Dimens.margin100), color: Theme.of(context).colorScheme.primary),
                                            height: Dimens.margin50,
                                            width: Dimens.margin50,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                APPImages.icStarPng,
                                                color: (recommendationsList.value[index].isFavourite ?? false) ? Colors.white : Colors.grey,
                                              ),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          recommendationsList.value[index].username ?? '',
                                          style: getTextStyleFromFont(
                                            shadow: <Shadow>[
                                              const Shadow(
                                                // offset: Offset(5.0, 5.0),
                                                blurRadius: Dimens.margin25,
                                                color: Color.fromARGB(255, 0, 0, 0),
                                              ),
                                            ],
                                            AppFont.poppins,
                                            Dimens.margin20,
                                            Theme.of(context).primaryColor,
                                            FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          '${recommendationsList.value[index].mutualInterests ?? ''} mutual interests',
                                          style: getTextStyleFromFont(
                                            AppFont.poppins,
                                            Dimens.margin18,
                                            Theme.of(context).primaryColor,
                                            FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
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
                                                    selectedIndex = index;
                                                    removeUserFromInterests(recommendationsList.value[index].userId ?? 0);
                                                  },
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: SizedBox(height: Dimens.margin50, width: Dimens.margin50, child: SvgPicture.asset(APPImages.icCross)),
                                            ),
                                          ),
                                          Visibility(
                                            visible: recommendationsList.value[index].isConnected == false,
                                            replacement: const SizedBox(),
                                            child: InkWell(
                                              onTap: () {
                                                selectedIndex = index;
                                                Navigator.pushNamed(context, AppRoutes.routesScreenSendRequest,
                                                        arguments: ModelRequestDataTransfer(toSendUserID: recommendationsList.value[index].userId))
                                                    .then(
                                                  (value) {
                                                    if (value != null) {
                                                      ModelNavigationBackHandling model = value as ModelNavigationBackHandling;
                                                      setState(() {
                                                        if (model.isConnected != null) {
                                                          recommendationsList.value[selectedIndex ?? 0].isConnected = model.isConnected;
                                                        }
                                                      });
                                                      // getRecommendations(id: updatedRelatedInterest ?? 0);
                                                    }
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: SizedBox(height: Dimens.margin50, width: Dimens.margin50, child: Image.asset(APPImages.icCennecButton)),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Visibility(
                visible: showLoadMore.value,
                child: InkWell(
                  onTap: () {
                    getRecommendations(
                      id: updatedRelatedInterest ?? 0,
                    );
                  },
                  child: Visibility(
                    visible: !paginationLoading.value,
                    replacement: const Center(
                      child: CommonLoadingAnimation(),
                    ),
                    child: SizedBox(
                      height: Dimens.margin300,
                      width: Dimens.margin150,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(Dimens.margin50)),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: Dimens.margin5,
                            ),
                            Text(
                              "Load More",
                              style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, Theme.of(context).colorScheme.primary, FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: [
          const SizedBox(height: Dimens.margin20),
          navigationWithLogo(),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: Dimens.margin20),
                interestsTitle(context),
                const SizedBox(height: Dimens.margin15),
                addOrRemoveButton(),
                const SizedBox(height: Dimens.margin20),
                cennectionWithThisText(),
                const SizedBox(height: Dimens.margin20),
                cennectionHorizontalGridview(),
                const SizedBox(height: Dimens.margin20),
                relatedInterestsText(),
                const SizedBox(height: Dimens.margin20),
                interestGridview()
              ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MultiValueListenableBuilder(
            valueListenables: [isLoading, modelRecommendations, isUpdating, recommendationsList, showLoadMore, paginationLoading],
            builder: (context, values, child) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<RecommendationsOfInterestBloc, RecommendationsOfInterestState>(
                    listener: (context, state) {
                      if (pageNumber == 1) {
                        isLoading.value = state is RecommendationsOfInterestLoading;
                      } else {
                        paginationLoading.value = state is RecommendationsOfInterestLoading;
                      }
                      if (state is RecommendationsOfInterestFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                      }
                      if (state is RecommendationsOfInterestResponse) {
                        modelRecommendations.value = state.modelRecommendations;
                        if (pageNumber == 1) {
                          recommendationsList.value.clear();
                          scrollController.jumpTo(0);
                        }
                        if (state.modelRecommendations.pagination?.nextPageUrl != null) {
                          pageNumber++;
                          showLoadMore.value = true;
                        } else {
                          showLoadMore.value = false;
                        }
                        recommendationsList.value.addAll((state.modelRecommendations.data ?? []).toList());
                      }
                    },
                  ),
                  BlocListener<AddRemoveInterestsBloc, AddRemoveInterestsState>(
                    listener: (context, state) {
                      isUpdating.value = state is AddRemoveInterestsLoading;
                      if (state is AddRemoveInterestsFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                      }
                      if (state is AddRemoveInterestsResponse) {
                        ToastController.showToast(context, state.modelAddOrRemoveInterests.message ?? '', true);
                        modelRecommendations.value.interestExists = !modelRecommendations.value.interestExists!;
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
                        printWrapped("in true");
                        recommendationsList.value[selectedIndex ?? 0].isFavourite = true;
                        Navigator.pushNamed(context, AppRoutes.routesScreenFavourite, arguments: ModelRequestDataTransfer(toSendUserID: selectedUserId)).then(
                          (value) {
                            if (value != null) {
                              // getRecommendations(
                              //     id: updatedRelatedInterest ?? 0,
                              // );
                            }
                          },
                        ); // ToastController.showToast(context, state.modelSuccess.message ?? '', true);
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
                        recommendationsList.value[selectedIndex ?? 0].isFavourite = false;
                        ToastController.showToast(context, state.modelSuccess.message ?? '', true);
                      }
                    },
                  ),
                  BlocListener<RemoveUserFromInterestsBloc, RemoveUserFromInterestsState>(
                    listener: (context, state) {
                      isLoading.value = state is RemoveUserFromInterestsLoading;
                      if (state is RemoveUserFromInterestsFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                      }
                      if (state is RemoveUserFromInterestsResponse) {
                        ToastController.showToast(context, state.modelSuccess.message ?? '', true);
                        recommendationsList.value.removeAt(selectedIndex ?? 0);
                        // getRecommendations();
                      }
                    },
                  ),
                ],
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: IgnorePointer(
                      ignoring: isLoading.value || isUpdating.value || paginationLoading.value,
                      child: Stack(
                        children: [
                          getBody(context),
                          Visibility(
                            visible: isLoading.value,
                            child: const Center(
                              child: CommonLoadingAnimation(),
                            ),
                          )
                        ],
                      )),
                ),
              );
            }));
  }

  void getRecommendations({required int id}) {
    BlocProvider.of<RecommendationsOfInterestBloc>(context)
        .add(RecommendationsOfInterest(url: "${AppUrls.apiGetRecommendationOfInterest(id)}&per_page=$perPage&page=$pageNumber"));
  }

  void addRemoveInts() {
    String url = modelRecommendations.value.interestExists == true ? AppUrls.apiRemoveInterests : AppUrls.apiAddInterests;

    Map<String, dynamic> body = {
      AppConfig.paramUserId: getUser().userData?.id ?? 0,
      AppConfig.paramInterestsId: updatedRelatedInterest,
    };

    BlocProvider.of<AddRemoveInterestsBloc>(context).add(AddRemoveInterests(url: url, body: body));
  }

  void addToFavourite(int toUserId) {
    Map<String, dynamic> body = {
      AppConfig.paramFavouriteBy: getUser().userData?.id ?? 0,
      AppConfig.paramFavouriteTo: toUserId,
    };

    BlocProvider.of<FavouritesBloc>(context).add(AddToFavourites(url: AppUrls.apiAddToFavourites, body: body));
  }

  void removeFromFavourite(int friendId) {
    BlocProvider.of<RemoveFromFavouriteBloc>(context).add(RemoveFromFavourite(url: AppUrls.apiRemoveFavourite(friendId)));
  }

  void removeUserFromInterests(int userId) {
    BlocProvider.of<RemoveUserFromInterestsBloc>(context).add(RemoveUserFromInterests(url: AppUrls.apiRemoveUser(userId)));
  }
}

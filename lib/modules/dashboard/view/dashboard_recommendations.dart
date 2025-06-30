import 'package:card_swiper/card_swiper.dart';
import 'package:cennec/modules/connections/bloc/add_to_favourite/favourites_bloc.dart';
import 'package:cennec/modules/connections/bloc/get_recommendations/get_recommendations_bloc.dart';
import 'package:cennec/modules/connections/bloc/removeFromFavourite/remove_from_favourite_bloc.dart';
import 'package:cennec/modules/connections/bloc/remove_user_from_details/remove_user_from_details_bloc.dart';
import 'package:cennec/modules/connections/model/model_recommendations.dart';
import 'package:cennec/modules/connections/model/model_send_request.dart';
import 'package:cennec/modules/core/common/widgets/dialog/cupertino_confirmation_dialog.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:cennec/modules/interests/model/model_interests.dart';
import 'package:cennec/modules/preferences/bloc/report_user/report_user_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/common/widgets/dialog/common_loading_animation.dart';
import '../../interests/model/navigation_back_handling_model.dart';

class DashboardRecommendations extends StatefulWidget {
  const DashboardRecommendations({super.key});

  @override
  State<DashboardRecommendations> createState() => _DashboardRecommendationsState();
}

class _DashboardRecommendationsState extends State<DashboardRecommendations> {
  Widget logo() {
    return Center(
      child: Image.asset(
        APPImages.icCennecBottom, // Update with your logo path
        height: 40,
      ),
    );
  }

  Widget findConnectionsText(BuildContext context) {
    return Text(
      // getTranslate(APPStrings.textAboutUs).toString(),
      'Find Connections',
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin25,
        AppColors.colorDarkBlue,
        FontWeight.w700,
      ),
    );
  }

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  ValueNotifier<ModelRecommendations> modelRecommendation = ValueNotifier(ModelRecommendations());
  ValueNotifier<List<RecommendationData>> recommendationList = ValueNotifier([]);
  int? selectedIndex;
  int perPage = 20;
  int pageNumber = 1;
  bool containsMoreData = false;

  @override
  void initState() {
    getRecommendation();
    super.initState();
  }

  // ValueNotifier<List<UserPreference>> dummyName = ValueNotifier([
  //   UserPreference(name: "Caroline", imageUrl: "https://4kwallpapers.com/images/walls/thumbs_3t/3228.jpg"),
  //   UserPreference(
  //       name: "Eunwoo",
  //       imageUrl: "https://m.media-amazon.com/images/M/MV5BNzFjODJhZDItNmI2Mi00MDdlLWI5NzQtMWM3MTUzNDVkMmE3XkEyXkFqcGdeQXVyNzY1ODU1OTk@._V1_FMjpg_UX1000_.jpg"),
  //   UserPreference(name: "Jennifer", imageUrl: "https://4kwallpapers.com/images/walls/thumbs_3t/3236.jpg"),
  //   UserPreference(name: "Rose", imageUrl: "https://4kwallpapers.com/images/walls/thumbs_3t/4677.jpg"),
  //   UserPreference(name: "Lee", imageUrl: "https://i.pinimg.com/736x/46/66/00/4666003da4b7304245c2801209d6d5c3.jpg"),
  //   UserPreference(name: "Rachel", imageUrl: "https://4kwallpapers.com/images/walls/thumbs_3t/3261.jpg")
  // ]);

  Widget connectionsCarousal() {
    return Swiper(
        onTap: (index) {
          selectedIndex = index;
          Navigator.pushNamed(context, AppRoutes.routesScreenUserDetails,
                  arguments: ModelRequestDataTransfer(getUserId: recommendationList.value[index].userId))
              .then(
            (value) {
              if (value != null) {
                ModelNavigationBackHandling model = value as ModelNavigationBackHandling;
                printWrapped("model data = ${model.isFavourite}");
                printWrapped("selected Index = $selectedIndex");
                setState(() {
                  if (model.isFavourite != null) {
                    recommendationList.value[selectedIndex ?? 0].isFavourite = model.isFavourite;
                  }
                  if (model.isRemoved != null && model.isRemoved == true) {
                    recommendationList.value.removeAt(selectedIndex ?? 0);
                  }
                  if(model.isConnected != null)
                  {
                    recommendationList.value[selectedIndex ?? 0].isConnected = model.isConnected;
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
        onIndexChanged: (value) {
          currentIndex.value = value;
          printWrapped("onIndexChanged = $value");
          if(containsMoreData && (value == (recommendationList.value.length - 3)))
            {
              getRecommendation();
            }
        },
        layout: SwiperLayout.TINDER,
        loop: false,
        itemHeight: Dimens.margin550,
        itemWidth: double.maxFinite,
        // physics: const BouncingScrollPhysics(),
        itemCount: recommendationList.value.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              // (recommendationList.value[index].profileImages ?? []).isNotEmpty && recommendationList.value[index].profileImages  != null
              recommendationList.value[index].defaultProfilePic != null
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
                        recommendationList.value[index].defaultProfilePic ?? '',
                        // width: Dimens.margin225,
                        height: Dimens.margin450,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(Dimens.margin30),
                      child: SizedBox(
                        height: Dimens.margin450,
                        // width: 225,
                        child: Image.asset(
                          APPImages.icDummyProfile,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              Container(
                height: Dimens.margin450,
                decoration: BoxDecoration(
                    // image: DecorationImage(image: NetworkImage(recommendationList.value[index].profileImages?[0].imageUrl ?? ''), fit: BoxFit.cover),
                    // color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Dimens.margin20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
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
                                  reportUser(recommendationList.value[index].userId ?? 0);
                                  // Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.margin100), color: Theme.of(context).colorScheme.primary),
                                height: Dimens.margin50,
                                width: Dimens.margin50,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    APPImages.icFlagSvg,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              // selectedUserId = modelRecommendations.value.data?[index].userId;
                              selectedIndex = index;
                              if (recommendationList.value[index].isFavourite ?? false) {
                                removeFromFavourite(recommendationList.value[index].userId ?? 0);
                              } else {
                                addToFavourite(recommendationList.value[index].userId ?? 0);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimens.margin20),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.margin100), color: Theme.of(context).colorScheme.primary),
                              height: Dimens.margin50,
                              width: Dimens.margin50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  APPImages.icStarPng,
                                  color: (recommendationList.value[index].isFavourite ?? false) ? Colors.white : Colors.grey,
                                ),
                              ),
                            ),
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
                              recommendationList.value[index].username ?? '',
                              style: getTextStyleFromFont(
                                shadow: <Shadow>[
                                  const Shadow(
                                    // offset: Offset(5.0, 5.0),
                                    blurRadius: Dimens.margin20,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                                AppFont.poppins,
                                Dimens.margin30,
                                Theme.of(context).primaryColor,
                                FontWeight.w700,
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
                                        removeUserFromDetails(recommendationList.value[index].userId ?? 0);
                                      },
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: SizedBox(height: Dimens.margin60, width: Dimens.margin60, child: SvgPicture.asset(APPImages.icCross)),
                                ),
                              ),
                              Visibility(
                                  visible: recommendationList.value[index].isConnected == false,
                                  replacement: const SizedBox(),
                                  child: InkWell(
                                    onTap: () {
                                      selectedIndex = index;
                                      Navigator.pushNamed(context, AppRoutes.routesScreenSendRequest,
                                              arguments: ModelRequestDataTransfer(toSendUserID: recommendationList.value[index].userId))
                                          .then(
                                        (value) {
                                          if (value != null) {
                                            ModelNavigationBackHandling model = value as ModelNavigationBackHandling;
                                            setState(() {
                                              if (model.isConnected != null) {
                                                recommendationList.value[selectedIndex ?? 0].isConnected = model.isConnected;
                                              }
                                            });
                                            // getRecommendations(id: updatedRelatedInterest ?? 0);
                                          }
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: SizedBox(height: Dimens.margin60, width: Dimens.margin60, child: Image.asset(APPImages.icCennecButton)),
                                    ),
                                  ))
                            ],
                          ),
                          // const SizedBox(
                          //   height: Dimens.margin50,
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget interestGridview(RecommendationData data) {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: Dimens.margin5,
      children: [
        ...List.generate(
          (data.userInterests ?? []).length,
          (index) => GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.routesScreenRecommendationOfInterests,
                  arguments: ModelInterestsDataTransfer(interestId: data.userInterests?[index].interestId, interestName: data.userInterests?[index].interestName)).then(
                    (value) {
                  if(value == true)
                  {
                    // getRecommendation();
                  }
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.margin5),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.3,
                  ),
                  color: hexToColor(data.userInterests?[index].interestColor ?? ''),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(Dimens.margin8),
                child: Text(
                  data.userInterests?[index].interestName ?? '',
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin15,
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

  Widget userPreferences(UserQueAns data) //todo in listview
  {
    return Container(
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
    );
  }

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Dimens.margin10),
            logo(),
            SizedBox(
              height: Dimens.margin450,
              child: Visibility(
                  visible: recommendationList.value.isNotEmpty,
                  replacement: Center(
                    child: Text(
                      isLoading.value ? "User's loading" : "No user available",
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        Dimens.margin18,
                        Theme.of(context).hintColor.withOpacity(0.9),
                        FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5) ?? FontWeight.w500,
                      ),
                    ),
                  ),
                  child: connectionsCarousal()),
            ),
            const SizedBox(height: Dimens.margin10),
            interestGridview(recommendationList.value.isNotEmpty ? recommendationList.value[currentIndex.value] : RecommendationData()),
            const SizedBox(height: Dimens.margin10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: recommendationList.value.isNotEmpty ? (recommendationList.value[currentIndex.value].userQueAns ?? []).length : 0,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: userPreferences(recommendationList.value[currentIndex.value].userQueAns?[index] ?? UserQueAns()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MultiValueListenableBuilder(
            valueListenables: [isLoading, modelRecommendation, recommendationList, currentIndex],
            builder: (context, values, child) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<GetRecommendationsBloc, GetRecommendationsState>(
                    listener: (context, state) {
                      isLoading.value = state is GetRecommendationsLoading;
                      if (state is GetRecommendationsFailure) {}
                      if (state is GetRecommendationsResponse) {
                        if(state.modelRecommendations.pagination?.nextPageUrl != null)
                          {
                            modelRecommendation.value = state.modelRecommendations;
                            containsMoreData = true;
                            pageNumber++;
                          }
                        else
                          {
                            containsMoreData = false;
                          }
                        recommendationList.value.addAll((state.modelRecommendations.data ?? []).toList());
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
                        recommendationList.value[selectedIndex ?? 0].isFavourite = true;
                        Navigator.pushNamed(context, AppRoutes.routesScreenFavourite,
                                arguments: ModelRequestDataTransfer(toSendUserID: recommendationList.value[selectedIndex ?? 0].userId))
                            .then(
                          (value) {
                            if (value != null && value == true) {
                              // getRecommendations();
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
                        recommendationList.value[selectedIndex ?? 0].isFavourite = false;
                        ToastController.showToast(context, state.modelSuccess.message ?? '', true);
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
                        recommendationList.value.removeAt(selectedIndex ?? 0);
                        ToastController.showToast(context, state.modelSuccess.message ?? '', true);
                        // getRecommendations();
                      }
                    },
                  ),
                ],
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: IgnorePointer(
                      ignoring: isLoading.value,
                      child: Stack(
                        children: [
                          getBody(context),
                          Visibility(
                              visible: isLoading.value,
                              child: const Center(
                                child: CommonLoadingAnimation(),
                              ))
                        ],
                      )),
                ),
              );
            }));
  }

  getRecommendation() {
    BlocProvider.of<GetRecommendationsBloc>(context).add(GetRecommendations(url: "${AppUrls.apiGetRecommendation}?per_page=$perPage&page=$pageNumber"));
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

  void reportUser(int toUserId) {
    Map<String, dynamic> body = {
      AppConfig.paramReportBy: getUser().userData?.id ?? 0,
      AppConfig.paramReportTo: toUserId,
    };
    BlocProvider.of<ReportUserBloc>(context).add(ReportUser(url: AppUrls.apiReportUser, body: body));
  }

  void removeUserFromDetails(int userId) {
    BlocProvider.of<RemoveUserFromDetailsBloc>(context).add(RemoveUserFromDetails(url: AppUrls.apiRemoveUser(userId)));
  }
}

//
// class UserPreference {
//   final String name;
//   bool isFavourite;
//   String? imageUrl;
//
//   UserPreference({required this.name, this.isFavourite = false, this.imageUrl});
// }

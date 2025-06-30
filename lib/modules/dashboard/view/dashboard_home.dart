import 'package:cennec/modules/connections/bloc/accept-reject_requests/accept_reject_requests_bloc.dart';
import 'package:cennec/modules/connections/bloc/my_connections/get_my_connections_bloc.dart';
import 'package:cennec/modules/connections/model/model_my_connections.dart';
import 'package:cennec/modules/connections/model/model_send_request.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/dashboard/bloc/requests_bloc/get_requests_bloc.dart';
import 'package:cennec/modules/dashboard/model/model_requests.dart';
import 'package:cennec/modules/interests/bloc/get_my_interests/get_my_interests_bloc.dart';
import 'package:cennec/modules/notifications/model/model_notification.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/utils/app_config.dart';
import '../../core/utils/common_import.dart';
import '../../interests/model/model_interests.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  ValueNotifier<List<ModelInterests>> modelInterestList = ValueNotifier([]);
  ValueNotifier<List<ModelInterests>> filterList = ValueNotifier([]);
  ValueNotifier<List<ConnectionsModel>> myConnections = ValueNotifier([]);
  ValueNotifier<ModelRequests> myRequests = ValueNotifier(ModelRequests());
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> showLoadMore = ValueNotifier(false);
  ValueNotifier<bool> paginationLoading = ValueNotifier(false);
  ValueNotifier<int> notificationCount = ValueNotifier(0);
  TextEditingController searchController = TextEditingController();
  ValueNotifier<int> navIndex = ValueNotifier(0);
  ScrollController scrollController = ScrollController();
  int connectionPageNumber = 1;
  late FocusNode _focusNode;


  @override
  void initState() {
    _focusNode = FocusNode();
    getInterests();
    checkNotificationPermission();
    super.initState();
  }


  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget logo() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 28,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              notificationCount.value.toString(),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: Dimens.margin12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.routesScreenNotifications).then(
              (value) {
                if (value == true) {
                  getInterests();
                }
              },
            );
          },
          icon: Icon(
            Icons.notifications,
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.8),
          ),
          iconSize: Dimens.margin30,
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

  Widget myInterestsTexts(BuildContext context) {
    return Row(
      children: [
        Text(
          "my interests",
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin20,
            Theme.of(context).hintColor,
            FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget myCennectionAndPendingText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => navIndex.value = 0,
          child: Text(
            "my cennections",
            style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin20,
              navIndex.value == 0 ? Theme.of(context).hintColor : Theme.of(context).colorScheme.onSecondary,
              FontWeight.w700,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            navIndex.value = 1;
          },
          child: Text(
            "requests(${myRequests.value.requestCount ?? 0})",
            style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin20,
              navIndex.value == 1 ? Theme.of(context).hintColor : Theme.of(context).colorScheme.onSecondary,
              FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget searchField(BuildContext context) {
    return BaseTextFormFieldRounded(
      borderRadius: Dimens.margin15,
      // hintText: getTranslate(APPStrings.textSearchForNewInterests),
      hintText: "Search through saved interests below",
      controller: searchController,
      focusNode: _focusNode,
      onChange: () {
        scrollController.jumpTo(0);
        searchAlgo();
      },
      onSubmit: () {
        FocusScope.of(context).unfocus();
      },
      // hintText: "Search for new interests",
      prefixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: Dimens.margin5,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(APPImages.icSearch),
          ),
        ],
      ),
      hintStyle: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin18,
        Theme.of(context).hintColor.withOpacity(0.9),
        FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5) ?? FontWeight.w500,
      ),
    );
  }

  /// This is the local search algorithm which is used for searching specific interests
  searchAlgo() {
    setState(() {
      if (searchController.text.length > 1) {
        filterList.value.clear();
        filterList.value.addAll(
            modelInterestList.value.where((interest) => (interest.interestName ?? '').toLowerCase().contains(searchController.text.toLowerCase())).toList());
      }
      if (searchController.text.length < 2) {
        filterList.value.clear();
        for (ModelInterests item in modelInterestList.value) {
          filterList.value.add(item);
        }
      }
    });
  }

  Widget interestGridview() {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: Dimens.margin5,
      children: [
        ...List.generate(
          filterList.value.length,
          (index) => GestureDetector(
            onTap: () {
              _focusNode.unfocus();
              Navigator.pushNamed(context, AppRoutes.routesScreenRecommendationOfInterests,
                      arguments: ModelInterestsDataTransfer(interestId: filterList.value[index].id, interestName: filterList.value[index].interestName))
                  .then(
                (value) {
                  if (value == true) {
                    getInterests();
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
                  /*olor: filterList.value[index].isInterestAdded == true
                      ?
                  hexToColor(filterList.value[index].interestColor ?? '')
                      : Theme.of(context).primaryColor,*/
                  color: hexToColor(filterList.value[index].interestColor ?? ''),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(Dimens.margin8),
                child: Text(
                  filterList.value[index].interestName ?? '',
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

  // List<UserPreference> dummyName = [
  //   UserPreference(name: "Caroline"),
  //   UserPreference(name: "Test User"),
  //   UserPreference(name: "Oggy"),
  // ];

  Widget connectionsGrid() {
    return IndexedStack(
      index: navIndex.value,
      children: [
        Visibility(
          visible: (myConnections.value ?? []).isNotEmpty,
          replacement: Center(
            child: Text(
              getTranslate(isLoading.value ? APPStrings.textLoadingConnection : APPStrings.textNoConnections),
              // isLoading.value ? "Loading Connections" : "No Connections",
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin18,
                Theme.of(context).hintColor,
                FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5) ?? FontWeight.w500,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: (myConnections.value).length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _focusNode.unfocus();
                        Navigator.pushNamed(context, AppRoutes.routesScreenUserDetails,
                            arguments: ModelRequestDataTransfer(getUserId: myConnections.value[index].id, isFromDashboard: true))
                            .then(
                          (value) {
                            if (value != null) {
                              getInterests();
                              connectionPageNumber = 1;
                            }
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            // (myConnections.value.data?[index].profileImages ?? []).isNotEmpty && myConnections.value.data?[index].profileImages != null
                            myConnections.value[index].defaultProfilePic != null
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
                                      myConnections.value[index].defaultProfilePic ?? '',
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
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.margin30)),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
                                  child: Text(
                                    myConnections.value[index].name ?? '',
                                    style: getTextStyleFromFont(
                                      shadow: <Shadow>[
                                        const Shadow(
                                          // offset: Offset(5.0, 5.0),
                                          blurRadius: Dimens.margin20,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ],
                                      AppFont.poppins,
                                      Dimens.margin20,
                                      Theme.of(context).primaryColor,
                                      FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
               Visibility(
                 visible: showLoadMore.value,
                 child: SizedBox(
                    width: Dimens.margin120,
                    child: Center(child: CommonButton(
                      height: 50,
                        text: "Load More",
                      onTap: () {
                        getMyConnections(pageNumber: connectionPageNumber);
                      },
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      isLoading: paginationLoading.value,
                    ),
                    )),
               )
            ],
          ),
        ),
        Visibility(
            visible: (myRequests.value.data ?? []).isNotEmpty,
            replacement: Center(
              child: Text(
                "No requests",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin18,
                  Theme.of(context).hintColor,
                  FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5) ?? FontWeight.w500,
                ),
              ),
            ),
            child: pendingRequests())
      ],
    );
  }

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Dimens.margin10),
          logo(),
          const SizedBox(height: Dimens.margin20),
          searchField(context),
          const SizedBox(height: Dimens.margin20),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  myInterestsTexts(context),
                  const SizedBox(height: Dimens.margin20),
                  Visibility(
                      visible: filterList.value.isNotEmpty,
                      replacement: Center(
                          child: Text(
                        getTranslate(isLoading.value ? APPStrings.textLoadingInterests : APPStrings.textNoInterests),
                        style: getTextStyleFromFont(
                          AppFont.poppins,
                          Dimens.margin18,
                          Theme.of(context).hintColor.withOpacity(0.9),
                          FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5) ?? FontWeight.w500,
                        ),
                      )),
                      child: interestGridview()),
                  const SizedBox(height: Dimens.margin20),
                  myCennectionAndPendingText(context),
                  const SizedBox(height: Dimens.margin20),
                  connectionsGrid()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pendingRequests() {
    return ListView.builder(
      itemCount: (myRequests.value.data ?? []).length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.routesScreenUserDetails,
                arguments: ModelRequestDataTransfer(getUserId: myRequests.value.data?[index].fromUserId, isFromDashboard: true)).then((value) {
                  if(value != null){
                    getInterests();
                  }
                },);
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myRequests.value.data?[index].userProfileImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(Dimens.margin70),
                          child: Image.network(
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child; // Image is fully loaded
                              }
                              return const Center(
                                child: CommonLoadingAnimation(), // Show the loading animation
                              );
                            },
                            myRequests.value.data?[index].userProfileImage ?? '',
                            width: Dimens.margin50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(Dimens.margin70),
                          child: SizedBox(
                            width: Dimens.margin50,
                            // height: Dimens.margin300,
                            child: Image.asset(
                              APPImages.icDummyProfile,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  const SizedBox(
                    width: Dimens.margin7,
                  ),
                  Expanded(
                    child: Text(
                      myRequests.value.data?[index].fromUser ?? '',
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        Dimens.margin18,
                        Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                        FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          takeAction(myRequests.value.data?[index] ?? NotificationData(), AppConfig.paramAccepted); //todo for connect
                        },
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.margin10), color: AppColors.colorBlack1),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              getTranslate(APPStrings.textConnect),
                              style: getTextStyleFromFont(
                                AppFont.poppins,
                                Dimens.margin12,
                                Theme.of(context).primaryColor,
                                FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: Dimens.margin5,
                      ),
                      Visibility(
                        visible: showLoadMore.value,
                        child: InkWell(
                          onTap: () {
                            takeAction(myRequests.value.data?[index] ?? NotificationData(), AppConfig.paramRejected); //todo for ignore
                          },
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.margin10), color: AppColors.colorBlack1),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                getTranslate(APPStrings.textIgnore),
                                style: getTextStyleFromFont(
                                  AppFont.poppins,
                                  Dimens.margin12,
                                  Theme.of(context).primaryColor,
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: Dimens.margin10,)
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MultiValueListenableBuilder(
            valueListenables: [navIndex, isLoading, modelInterestList, filterList, myConnections, notificationCount, myRequests,showLoadMore,paginationLoading],
            builder: (context, values, child) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<GetMyInterestsBloc, GetMyInterestsState>(
                    listener: (context, state) {
                      isLoading.value = state is GetMyInterestsLoading;
                      if (state is GetMyInterestsFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                      }
                      if (state is GetMyInterestsResponse) {
                        if ((state.modelInterestsList.data ?? []).isEmpty) {
                          NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                            AppRoutes.routesScreenSignupInterests,
                            (route) => false,
                          );
                        } else {
                          notificationCount.value = state.modelInterestsList.notificationCount ?? 0;
                          getMyConnections(pageNumber: connectionPageNumber);
                          modelInterestList.value.clear();
                          filterList.value.clear();
                          for (ModelInterests modelInterests in state.modelInterestsList.data ?? []) {
                            modelInterestList.value.add(ModelInterests(
                                id: modelInterests.id,
                                interestName: modelInterests.interestName,
                                interestColor: modelInterests.interestColor,
                                isInterestAdded: modelInterests.isInterestAdded));
                            filterList.value.add(ModelInterests(
                                id: modelInterests.id,
                                interestName: modelInterests.interestName,
                                interestColor: modelInterests.interestColor,
                                isInterestAdded: modelInterests.isInterestAdded));
                          }
                        }
                        // modelInterestList.value = state.modelInterestsList.data ?? [];
                        // filterList.value = state.modelInterestsList.data ?? [];
                      }
                    },
                  ),
                  BlocListener<GetMyConnectionsBloc, GetMyConnectionsState>(
                    listener: (context, state) {
                      if(connectionPageNumber > 1)
                        {
                          paginationLoading.value = state is GetMyConnectionsLoading;
                        }
                      else {
                        isLoading.value = state is GetMyConnectionsLoading;
                      }

                      if (state is GetMyConnectionsFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                      }
                      if (state is GetMyConnectionsResponse) {
                        if(connectionPageNumber == 1)
                        {
                          myConnections.value.clear();
                          getRequests();
                        }
                        if(state.modelMyConnections.pagination?.nextPageUrl != null)
                          {
                            connectionPageNumber++;
                            showLoadMore.value = true;
                          }
                        else
                          {
                            showLoadMore.value = false;
                          }
                        myConnections.value.addAll((state.modelMyConnections.data ?? []).toList());
                      }
                    },
                  ),
                  BlocListener<GetRequestsBloc, GetRequestsState>(
                    listener: (context, state) {
                      isLoading.value = state is GetRequestsLoading;
                      if (state is GetRequestsFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                      }
                      if (state is GetRequestsResponse) {
                        myRequests.value = state.modelRequests;
                      }
                    },
                  ),
                  BlocListener<AcceptRejectRequestsBloc, AcceptRejectRequestsState>(
                    listener: (context, state) {
                      isLoading.value = state is AcceptRejectRequestsLoading;
                      if (state is AcceptRejectRequestsFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                      }
                      if (state is AcceptRejectRequestsResponse) {
                        connectionPageNumber = 1;
                        getMyConnections(pageNumber: connectionPageNumber);
                      }
                    },
                  ),
                ],
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: IgnorePointer(
                      ignoring: isLoading.value || paginationLoading.value,
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

  checkNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      Permission.notification.request();
    }
  }

  void getInterests() {
    BlocProvider.of<GetMyInterestsBloc>(context).add(GetMyInterests(url: AppUrls.apiGetMyInterests(getUser().userData?.id ?? 0)));
  }

  void getMyConnections({required int pageNumber}) {
    BlocProvider.of<GetMyConnectionsBloc>(context).add(GetMyConnections(url: "${AppUrls.apiMyConnections}?page=$pageNumber&per_page=20"));
  }

  void getRequests() {
    BlocProvider.of<GetRequestsBloc>(context).add(GetRequests(url: AppUrls.apiGetRequests));
  }

  takeAction(NotificationData data, String action) {
    Map<String, dynamic> body = {
      AppConfig.paramActionBy: getUser().userData?.id ?? 0,
      AppConfig.paramActionTo: data.fromUserId,
      AppConfig.paramRequestStatus: action,
    };
    BlocProvider.of<AcceptRejectRequestsBloc>(context).add(AcceptRejectRequests(body: body, url: AppUrls.apiAcceptRejectRequests));
  }
}

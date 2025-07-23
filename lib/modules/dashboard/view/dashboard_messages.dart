import 'package:cennec/modules/chat/bloc/message_list_bloc.dart';
import 'package:cennec/modules/chat/models/MessageListResponse.dart';
import 'package:cennec/modules/chat/models/MessageRoomRequestData.dart';
import 'package:cennec/modules/connections/bloc/get_my_favourites/get_my_favourites_bloc.dart';
import 'package:cennec/modules/connections/bloc/my_connections/get_my_connections_bloc.dart';
import 'package:cennec/modules/connections/model/model_my_connections.dart';
import 'package:cennec/modules/connections/model/model_my_favourites.dart';
import 'package:cennec/modules/connections/model/model_send_request.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:cennec/modules/interests/model/model_interests.dart';
import 'package:flutter/cupertino.dart';

import '../../core/common/widgets/button.dart';

class DashboardMessages extends StatefulWidget {
  const DashboardMessages({super.key});

  @override
  State<DashboardMessages> createState() => _DashboardMessagesState();
}

class _DashboardMessagesState extends State<DashboardMessages> {
  ValueNotifier<int> navIndex = ValueNotifier(0);
  ValueNotifier<List<ConnectionsModel>> myConnections = ValueNotifier([]);
  ValueNotifier<List<FavouritesModel>> myFavourites = ValueNotifier([]);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  int connectionPageNumber = 1;
  int favouritePageNumber = 1;
  ValueNotifier<bool> showLoadMoreForConnection = ValueNotifier(false);
  ValueNotifier<bool> showLoadMoreForFavourite = ValueNotifier(false);
  ValueNotifier<bool> paginationLoading = ValueNotifier(false);

  @override
  void initState() {
    getMyConnections(pageNumber: connectionPageNumber);
    getMessageList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget logo() {
    return Center(
      child: Image.asset(
        APPImages.icCennecBottom, // Update with your logo path
        height: 40,
      ),
    );
  }

  Widget myMessages(BuildContext context) {
    return Row(
      children: [
        Text(
          "messages",
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

  Widget myCennectionAndFavouriteText(BuildContext context) {
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
          onTap: () => navIndex.value = 1,
          child: Text(
            "my favorites",
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


  Widget buildTabSwitcher() {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.colorSelectedInterestChip,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => navIndex.value = 0,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: navIndex.value == 0 ? AppColors.colorWhite : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "My Cennections",
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    14,
                    AppColors.colorBlack,
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => navIndex.value = 1,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: navIndex.value == 1 ? AppColors.colorWhite : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "My Favorites",
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    14,
                    AppColors.colorBlack,
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  final List<Interest> interests = [
    Interest(name: 'Interior design'),
    Interest(name: 'Economics'),
    Interest(name: 'Engineering'),
    Interest(name: 'Entrepreneurship'),
    Interest(name: 'Health care'),
  ];

  Widget messagesGridview() {
    if (messageList.value.isEmpty) {
      return Text('No Data Found', style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, CupertinoColors.activeBlue, FontWeight.w600));
    } else {
      return Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: Dimens.margin80,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: messageList.value.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.routesScreenChats,
                      arguments: MessageRoomRequestData(
                          fromUserId: messageList.value[index].id!,
                          page: 1,
                          name: messageList.value[index].username!,
                          imageUrl: messageList.value[index].defaultProfilePicture ?? ''));
                },
                child: Stack(
                  children: [
                    messageList.value[index].defaultProfilePicture != null
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
                              messageList.value[index].defaultProfilePicture ?? '',
                              width: Dimens.margin70,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(Dimens.margin70),
                            child: SizedBox(
                              width: Dimens.margin70,
                              // height: Dimens.margin300,
                              child: Image.asset(
                                APPImages.icDummyProfile,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                            // image: const DecorationImage(image: AssetImage(APPImages.icDummyProfile), fit: BoxFit.cover),
                            // color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(Dimens.margin70)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }

  ValueNotifier<List<MessageList>> messageList = ValueNotifier([]);

  Widget connectionsGrid() {
    return IndexedStack(
      index: navIndex.value,
      children: [
        // === CONNECTIONS TAB ===
        Visibility(
          visible: messageList.value.isNotEmpty,
          replacement: Center(
            child: Text(
              getTranslate(isLoading.value ? APPStrings.textLoadingConnection : APPStrings.textNoConnections),
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin18,
                Theme.of(context).hintColor,
                FontWeight.w500,
              ),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: messageList.value.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final user = messageList.value[index];
                    final messageTime = user.latestMessageTime != null
                        ? DateTime.tryParse(user.latestMessageTime!) ?? DateTime.now()
                        : DateTime.now();

                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.routesScreenChats,
                          arguments: MessageRoomRequestData(
                            fromUserId: user.id!,
                            page: 1,
                            name: user.username ?? '',
                            imageUrl: user.defaultProfilePicture ?? '',
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.colorWhite,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.colorGreyExtraLight,
                              backgroundImage: user.defaultProfilePicture != null
                                  ? NetworkImage(user.defaultProfilePicture!)
                                  : null,
                              child: user.defaultProfilePicture == null
                                  ? Text(
                                user.username?.substring(0, 1).toUpperCase() ?? "?",
                                style: getTextStyleFromFont(AppFont.poppins, 18, AppColors.colorWhite, FontWeight.bold),
                              )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.username ?? '',
                                    style: getTextStyleFromFont(AppFont.poppins, 16, AppColors.colorBlack, FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  // Uncomment when backend sends message preview
                                  Text(
                                    user.lastMessage ?? '',
                                    style: getTextStyleFromFont(
                                        AppFont.poppins,
                                        14,
                                        AppColors.colorHyperLink80,
                                        FontWeight.normal
                                    ),
                                    maxLines: 1, // Limits text to a single line
                                    overflow: TextOverflow.ellipsis, // Adds ... when text overflows
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                // Container(
                                //   width: 8,
                                //   height: 8,
                                //   decoration: const BoxDecoration(
                                //     shape: BoxShape.circle,
                                //     color: Colors.black,
                                //   ),
                                // ),
                                // const SizedBox(width: 4),
                                Text(
                                  getRelativeTime(messageTime),
                                  style: getTextStyleFromFont(AppFont.poppins, 12, AppColors.colorBlack1, FontWeight.normal),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),        // === FAVORITES TAB ===
        Visibility(
          visible: myFavourites.value.isNotEmpty,
          replacement: Center(
            child: Text(
              getTranslate(isLoading.value ? APPStrings.textLoadingConnection : APPStrings.textNoConnections),
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin18,
                Theme.of(context).hintColor,
                FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5) ?? FontWeight.w500,
              ),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: myFavourites.value.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final fav = myFavourites.value[index];
                    return InkWell(
                      onTap: () {
                        if (fav.isConnected == true) {
                          Navigator.pushNamed(context, AppRoutes.routesScreenChats,
                              arguments: MessageRoomRequestData(
                                fromUserId: fav.id!,
                                page: 1,
                                name: fav.name!,
                                imageUrl: fav.defaultProfilePic ?? '',
                              ));
                        } else {
                          Navigator.pushNamed(context, AppRoutes.routesScreenUserDetails,
                              arguments: ModelRequestDataTransfer(
                                getUserId: fav.id,
                                isFromDashboard: true,
                              ));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          color: AppColors.colorWhite,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.colorGreyExtraLight,
                              backgroundImage: fav.defaultProfilePic != null
                                  ? NetworkImage(fav.defaultProfilePic!)
                                  : null,
                              child: fav.defaultProfilePic == null
                                  ? Text(
                                fav.name?.substring(0, 1).toUpperCase() ?? "?",
                                style: getTextStyleFromFont(AppFont.poppins, 18, AppColors.colorWhite, FontWeight.bold),
                              )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fav.name ?? '',
                                    style: getTextStyleFromFont(AppFont.poppins, 16, AppColors.colorBlack, FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: showLoadMoreForFavourite.value,
                  child: Center(
                    child: CommonButton(
                      height: 48,
                      text: "Load More",
                      onTap: () {
                        getMYFavourites(pageNumber: favouritePageNumber);
                      },
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      isLoading: paginationLoading.value,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: Dimens.margin10),
          // logo(),
          // const SizedBox(height: Dimens.margin20),
          // myMessages(context),
          const SizedBox(height: Dimens.margin20),
          // messagesGridview(),
          Text("Messages", style:  getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin28,
            AppColors.colorDarkBlue,
            FontWeight.w600,
          )),
          const SizedBox(height: Dimens.margin20),
          buildTabSwitcher(),
          const SizedBox(height: Dimens.margin20),
          Expanded(
            child: connectionsGrid(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MultiValueListenableBuilder(
            valueListenables: [
          paginationLoading,
          showLoadMoreForConnection,
          showLoadMoreForFavourite,
          isLoading,
          myConnections,
          navIndex,
          myFavourites,
          messageList
        ],
            builder: (context, values, child) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<GetMyConnectionsBloc, GetMyConnectionsState>(
                    listener: (context, state) {
                      if (connectionPageNumber > 1) {
                        paginationLoading.value = state is GetMyConnectionsLoading;
                      } else {
                        isLoading.value = state is GetMyConnectionsLoading;
                      }

                      if (state is GetMyConnectionsFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                      }
                      if (state is GetMyConnectionsResponse) {
                        if (connectionPageNumber == 1) {
                          getMYFavourites(pageNumber: favouritePageNumber);
                        }
                        if (connectionPageNumber == 1) {
                          myConnections.value.clear();
                        }
                        if (state.modelMyConnections.pagination?.nextPageUrl != null) {
                          connectionPageNumber++;
                          showLoadMoreForConnection.value = true;
                        } else {
                          showLoadMoreForConnection.value = false;
                        }
                        myConnections.value.addAll((state.modelMyConnections.data ?? []).toList());

                      }
                    },
                  ),
                  BlocListener<GetMyFavouritesBloc, GetMyFavouritesState>(
                    listener: (context, state) {
                      if (favouritePageNumber > 1) {
                        paginationLoading.value = state is GetMyFavouritesLoading;
                      } else {
                        isLoading.value = state is GetMyFavouritesLoading;
                      }
                      if (state is GetMyFavouritesFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                      }
                      if (state is GetMyFavouritesResponse) {
                        if (favouritePageNumber == 1) {
                          myFavourites.value.clear();
                        }
                        if (state.modelMyFavourites.pagination?.nextPageUrl != null) {
                          showLoadMoreForFavourite.value = true;
                          favouritePageNumber++;
                        } else {
                          showLoadMoreForFavourite.value = false;
                        }
                        myFavourites.value.addAll((state.modelMyFavourites.data ?? []).toList());
                      }
                    },
                  ),
                  BlocListener<MessageListBloc, MessageListState>(
                    listener: (context, state) {
                      if (state is MessageListSuccess) {
                        print('dataataa ${state.modelSuccess.data}');
                        messageList.value = state.modelSuccess.data;
                      } else if (state is MessageListFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                      }
                    },
                  )
                ],
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: AppColors.colorRoundedBgContainer,
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

  void getMyConnections({required int pageNumber}) {
    BlocProvider.of<GetMyConnectionsBloc>(context).add(GetMyConnections(url: "${AppUrls.apiMyConnections}?page=$pageNumber&per_page=15"));
  }

  void getMessageList() {
    BlocProvider.of<MessageListBloc>(context).add(GetMessageList(url: AppUrls.apiMessageList));
  }

  void getMYFavourites({required int pageNumber}) {
    BlocProvider.of<GetMyFavouritesBloc>(context).add(GetMyFavourites(url: "${AppUrls.apiMyFavourites}?page=$pageNumber&per_page=15"));
  }
}

String getRelativeTime(DateTime messageTime) {
  final now = DateTime.now();
  final difference = now.difference(messageTime);

  if (difference.inSeconds < 60) {
    return 'now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return '${weeks}w ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '${months}mo ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return '${years}y ago';
  }
}

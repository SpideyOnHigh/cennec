import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../connections/bloc/my_connections/get_my_connections_bloc.dart';
import '../../connections/bloc/removeFromFavourite/remove_from_favourite_bloc.dart';
import '../../connections/bloc/add_to_favourite/favourites_bloc.dart';
import '../../connections/model/model_my_connections.dart';
import '../../connections/model/model_send_request.dart';
import '../../core/common/widgets/dialog/common_loading_animation.dart';
import '../../core/common/widgets/toast_controller.dart';
import '../../core/utils/app_config.dart';
import '../../core/utils/app_urls.dart';
import '../../core/utils/common_import.dart';

class MyConnections extends StatefulWidget {
  final Function(bool)? onConnectionUpdate;

  const MyConnections({super.key, this.onConnectionUpdate});

  @override
  State<MyConnections> createState() => _MyConnectionsState();
}

class _MyConnectionsState extends State<MyConnections> {
  ValueNotifier<List<ConnectionsModel>> allConnections = ValueNotifier([]);
  ValueNotifier<List<ConnectionsModel>> myFavoriteConnections = ValueNotifier([]);
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  ValueNotifier<bool> isApiBusy = ValueNotifier(false);

  int connectionPageNumber = 1;
  int favoritePageNumber = 1;
  bool isFavouriteView = false;

  @override
  void initState() {
    super.initState();
    getMyConnections(pageNumber: connectionPageNumber);
    // Load favorites initially
    getFavoriteConnections(pageNumber: favoritePageNumber);
  }

  void addToFavourite(int toUserId) {
    isApiBusy.value = true;
    final body = {
      AppConfig.paramFavouriteBy: getUser().userData?.id ?? 0,
      AppConfig.paramFavouriteTo: toUserId,
    };
    BlocProvider.of<FavouritesBloc>(context).add(
      AddToFavourites(url: AppUrls.apiAddToFavourites, body: body),
    );
  }

  void removeFromFavourite(int userId) {
    isApiBusy.value = true;
    BlocProvider.of<RemoveFromFavouriteBloc>(context).add(
      RemoveFromFavourite(url: AppUrls.apiRemoveFavourite(userId)),
    );
  }

  void getMyConnections({required int pageNumber}) {
    if (!isFavouriteView) {
      isLoading.value = true;
    }
    BlocProvider.of<GetMyConnectionsBloc>(context).add(
      GetMyConnections(url: "${AppUrls.apiMyConnections}?page=$pageNumber&per_page=20"),
    );
  }

  void getFavoriteConnections({required int pageNumber}) {
    if (isFavouriteView) {
      isLoading.value = true;
    }
    // Assuming you have a favorites endpoint - adjust URL as per your API
    BlocProvider.of<GetMyConnectionsBloc>(context).add(
      GetMyConnections(url: "${AppUrls.apiMyFavourites}?page=$pageNumber&per_page=20"),
    );
  }

  void toggleFavoriteView() {
    setState(() {
      isFavouriteView = !isFavouriteView;
      if (isFavouriteView) {
        // Load favorites when switching to favorite view
        favoritePageNumber = 1;
        getFavoriteConnections(pageNumber: favoritePageNumber);
      } else {
        // Load regular connections when switching back
        connectionPageNumber = 1;
        getMyConnections(pageNumber: connectionPageNumber);
      }
    });
  }

  // Filter connections based on current view
  List<ConnectionsModel> getCurrentConnections() {
    if (isFavouriteView) {
      return myFavoriteConnections.value;
    } else {
      // Return only non-favorite connections for regular view
      return allConnections.value.where((connection) =>
      connection.isFavourite != true
      ).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FavouritesBloc, FavouritesState>(
          listener: (context, state) {
            if (state is FavouritesFailure) {
              ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
              isApiBusy.value = false;
            }
            if (state is FavouritesResponse) {
              ToastController.showToast(context, "Added to Favourites", true);

              // Update the user's favorite status in all connections
              // _updateUserFavoriteStatus(state.userId ?? 0, true);

              // Refresh both lists to ensure consistency
              connectionPageNumber = 1;
              favoritePageNumber = 1;
              getMyConnections(pageNumber: connectionPageNumber);
              getFavoriteConnections(pageNumber: favoritePageNumber);
            }
          },
        ),
        BlocListener<RemoveFromFavouriteBloc, RemoveFromFavouriteState>(
          listener: (context, state) {
            if (state is RemoveFromFavouriteFailure) {
              ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
              isApiBusy.value = false;
            }
            if (state is RemoveFromFavouriteResponse) {
              ToastController.showToast(context, "Removed from Favourites", true);

              // Update the user's favorite status
              // _updateUserFavoriteStatus(state.userId ?? 0, false);

              // Refresh both lists to ensure consistency
              connectionPageNumber = 1;
              favoritePageNumber = 1;
              getMyConnections(pageNumber: connectionPageNumber);
              getFavoriteConnections(pageNumber: favoritePageNumber);
            }
          },
        ),
        BlocListener<GetMyConnectionsBloc, GetMyConnectionsState>(
          listener: (context, state) {
            if (state is GetMyConnectionsFailure) {
              ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
              isLoading.value = false;
              isApiBusy.value = false;
            }

            if (state is GetMyConnectionsResponse) {
              if (isFavouriteView) {
                myFavoriteConnections.value = state.modelMyConnections.data ?? [];
              } else {
                // Store all connections (including favorites) but filter them in getCurrentConnections()
                allConnections.value = state.modelMyConnections.data ?? [];
              }
              isLoading.value = false;
              isApiBusy.value = false;
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.colorRoundedBgContainer,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          titleSpacing: 16,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isFavouriteView ? "My Favourites" : "My Connections",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin26,
                  Theme.of(context).colorScheme.onBackground,
                  FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: toggleFavoriteView,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.colorWhite,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Icon(
                    isFavouriteView ? Icons.star_rounded : Icons.star_border_rounded,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (context, loading, _) {
            if (loading) {
              return const Center(child: CommonLoadingAnimation());
            }

            return MultiValueListenableBuilder(
              valueListenables: [allConnections, myFavoriteConnections],
              builder: (context, values, _) {
                final currentConnections = getCurrentConnections();

                if (currentConnections.isEmpty) {
                  return Center(
                    child: Text(
                      isFavouriteView
                          ? getTranslate(APPStrings.textNoFavourites)
                          : getTranslate(APPStrings.textNoConnections),
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        Dimens.margin18,
                        Theme.of(context).hintColor,
                        FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ValueListenableBuilder<bool>(
                  valueListenable: isApiBusy,
                  builder: (context, showBusy, _) {
                    return Stack(
                      children: [
                        RefreshIndicator(
                          onRefresh: () async {
                            if (isFavouriteView) {
                              favoritePageNumber = 1;
                              getFavoriteConnections(pageNumber: favoritePageNumber);
                            } else {
                              connectionPageNumber = 1;
                              getMyConnections(pageNumber: connectionPageNumber);
                            }
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                            itemCount: currentConnections.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return _buildConnectionCard(currentConnections[index]);
                            },
                          ),
                        ),
                        if (showBusy)
                          const Center(
                            child: CommonLoadingAnimation(),
                          ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Helper method to update favorite status in the current list
  void _updateUserFavoriteStatus(int userId, bool isFavorite) {
    // Update in all connections list
    final connections = allConnections.value;
    for (int i = 0; i < connections.length; i++) {
      if (connections[i].id == userId) {
        connections[i].isFavourite = isFavorite;
        break;
      }
    }
    allConnections.value = List.from(connections);

    // Update favorites list
    final favoriteConnections = myFavoriteConnections.value;
    if (isFavorite) {
      // Find the user in all connections and add to favorites if not already there
      final user = connections.firstWhere(
            (conn) => conn.id == userId,
        orElse: () => ConnectionsModel(),
      );
      if (user.id != null && !favoriteConnections.any((fav) => fav.id == userId)) {
        favoriteConnections.add(user);
      }
    } else {
      // Remove from favorites list
      favoriteConnections.removeWhere((conn) => conn.id == userId);
    }
    myFavoriteConnections.value = List.from(favoriteConnections);
  }

  Widget _buildConnectionCard(ConnectionsModel user) {
    final List<UserInterest> interests = user.userInterest ?? [];
    const int maxVisibleInterests = 3; // Adjust for 2-line layout

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.routesScreenUserDetails,
          arguments: ModelRequestDataTransfer(
            getUserId: user.id,
            isFromDashboard: true,
          ),
        ).then((value) {
          if (value != null) {
            widget.onConnectionUpdate?.call(true);
            if (isFavouriteView) {
              favoritePageNumber = 1;
              getFavoriteConnections(pageNumber: favoritePageNumber);
            } else {
              connectionPageNumber = 1;
              getMyConnections(pageNumber: connectionPageNumber);
            }
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.colorWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Row
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.colorGreyExtraLight,
                  backgroundImage: user.defaultProfilePic != null
                      ? NetworkImage(user.defaultProfilePic!)
                      : null,
                  child: user.defaultProfilePic == null
                      ? Text(
                    user.name?.substring(0, 1).toUpperCase() ?? "?",
                    style: getTextStyleFromFont(AppFont.poppins, 18, AppColors.colorWhite, FontWeight.bold),
                  )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user.name ?? '',
                    style: getTextStyleFromFont(AppFont.poppins, 16, AppColors.colorBlack, FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (user.isFavourite == true) {
                      removeFromFavourite(user.id ?? 0);
                    } else {
                      addToFavourite(user.id ?? 0);
                    }
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      user.isFavourite == true ? Icons.star_rounded : Icons.star_border_rounded,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Bio
            if ((user.userInfo?.bio ?? "").isNotEmpty)
              Text(
                user.userInfo!.bio!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: getTextStyleFromFont(AppFont.poppins, 14, AppColors.colorBlack1, FontWeight.w400),
              ),

            // Interests
            if (interests.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...interests.take(maxVisibleInterests).map((interest) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.colorRoundedBgContainer,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        interest.interestName ?? '',
                        style: getTextStyleFromFont(AppFont.poppins, 14, AppColors.colorBlack, FontWeight.w500),
                      ),
                    );
                  }),
                  if (interests.length > maxVisibleInterests)
                    InkWell(
                      onTap: () {
                        // Same navigation to full profile
                        Navigator.pushNamed(
                          context,
                          AppRoutes.routesScreenUserDetails,
                          arguments: ModelRequestDataTransfer(
                            getUserId: user.id,
                            isFromDashboard: true,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.colorRoundedBgContainer,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          '+${interests.length - maxVisibleInterests} more',
                          style: getTextStyleFromFont(AppFont.poppins, 14, AppColors.colorHyperLink, FontWeight.w500),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
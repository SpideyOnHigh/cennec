

// class ScreenFindConnectionsSignup extends StatefulWidget {
//   const ScreenFindConnectionsSignup({super.key});
//
//   @override
//   State<ScreenFindConnectionsSignup> createState() => _FindConnectionsSignupState();
// }
//
// class _FindConnectionsSignupState extends State<ScreenFindConnectionsSignup> {
//   ValueNotifier<bool> isLoading = ValueNotifier(false);
//   ValueNotifier<int> currentIndex = ValueNotifier(0);
//   ValueNotifier<ModelRecommendations> modelRecommendation = ValueNotifier(ModelRecommendations());
//   ValueNotifier<List<RecommendationData>> recommendationList = ValueNotifier([]);
//   int? selectedIndex;
//   int perPage = 20;
//   int pageNumber = 1;
//   bool containsMoreData = false;
//
//   @override
//   void initState() {
//     getRecommendation();
//     super.initState();
//   }
//
//   Widget navigationWithLogo() {
//     return Stack(
//       children: [
//         // InkWell(
//         //   onTap: () {
//         //     Navigator.pop(context);
//         //   },
//         //   child: Padding(
//         //     padding: const EdgeInsets.all(Dimens.margin16),
//         //     child: Image.asset(
//         //       APPImages.icBack,
//         //       color: Theme.of(context).colorScheme.onSecondary, // Update with your logo path
//         //       height: Dimens.margin30,
//         //       width: Dimens.margin30,
//         //     ),
//         //   ),
//         // ),
//         Center(
//           child: Image.asset(
//             APPImages.icLogoWithName, // Update with your logo path
//             height: 80,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget findConnectionsText(BuildContext context) {
//     return Text(
//       getTranslate(APPStrings.textFindConnections).toString(),
//       // 'Find Connections',
//       textAlign: TextAlign.center,
//       style: getTextStyleFromFont(
//         AppFont.poppins,
//         Dimens.margin25,
//         AppColors.colorDarkBlue,
//         FontWeight.w700,
//       ),
//     );
//   }
//
//   Widget goToDashboardButton(BuildContext context) {
//     return CommonButton(
//       text: getTranslate(APPStrings.textGoToDashboard),
//       // text: 'Go To Dashboard',
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       onTap: () {
//         Navigator.pushNamedAndRemoveUntil(context, AppRoutes.routesScreenDashboard,(route) => false,);
//       },
//     );
//   }
//
//   // ValueNotifier<List<UserPreference>> dummyName = ValueNotifier([
//   //   UserPreference(name: "Caroline",imageUrl: "https://4kwallpapers.com/images/walls/thumbs_3t/3228.jpg"),
//   //   UserPreference(name: "Eunwoo",imageUrl: "https://m.media-amazon.com/images/M/MV5BNzFjODJhZDItNmI2Mi00MDdlLWI5NzQtMWM3MTUzNDVkMmE3XkEyXkFqcGdeQXVyNzY1ODU1OTk@._V1_FMjpg_UX1000_.jpg"),
//   //   UserPreference(name: "Jennifer",imageUrl: "https://4kwallpapers.com/images/walls/thumbs_3t/3236.jpg"),
//   //   UserPreference(name: "Rose",imageUrl: "https://4kwallpapers.com/images/walls/thumbs_3t/4677.jpg"),
//   //   UserPreference(name: "Lee",imageUrl: "https://i.pinimg.com/736x/46/66/00/4666003da4b7304245c2801209d6d5c3.jpg"),
//   //   UserPreference(name: "Rachel",imageUrl:"https://4kwallpapers.com/images/walls/thumbs_3t/3261.jpg" )]);
//
//   Widget connectionsCarousal() {
//     return Swiper(
//         onTap: (index) {
//           selectedIndex = index;
//           Navigator.pushNamed(context, AppRoutes.routesScreenUserDetails,
//                   arguments: ModelRequestDataTransfer(getUserId: recommendationList.value[index].userId))
//               .then(
//             (value) {
//               if (value != null) {
//                 ModelNavigationBackHandling model = value as ModelNavigationBackHandling;
//                 printWrapped("model data = ${model.isFavourite}");
//                 printWrapped("selected Index = $selectedIndex");
//                 setState(() {
//                   if (model.isFavourite != null) {
//                     recommendationList.value[selectedIndex ?? 0].isFavourite = model.isFavourite;
//                   }
//                   if (model.isRemoved != null && model.isRemoved == true) {
//                     recommendationList.value.removeAt(selectedIndex ?? 0);
//                   }
//                   if(model.isConnected != null)
//                   {
//                     recommendationList.value[selectedIndex ?? 0].isConnected = model.isConnected;
//                   }
//                 });
//                 // printWrapped("refreshed");
//                 // printWrapped("page nuimber = $pageNumber");
//                 // getRecommendations(
//                 //     id: updatedRelatedInterest ?? 0,
//                 // );
//               }
//             },
//           );
//         },
//         onIndexChanged: (value) {
//           currentIndex.value = value;
//           printWrapped("onIndexChanged = $value");
//           if(containsMoreData && (value == (recommendationList.value.length - 3)))
//           {
//             getRecommendation();
//           }
//         },
//         layout: SwiperLayout.TINDER,
//         loop: false,
//         itemHeight: Dimens.margin550,
//         itemWidth: double.maxFinite,
//         // physics: const BouncingScrollPhysics(),
//         itemCount: recommendationList.value.length,
//         itemBuilder: (context, index) {
//           return Stack(
//             children: [
//               // (recommendationList.value[index].profileImages ?? []).isNotEmpty && recommendationList.value[index].profileImages  != null
//               recommendationList.value[index].defaultProfilePic != null
//                   ? ClipRRect(
//                 borderRadius: BorderRadius.circular(Dimens.margin30),
//                 child: Image.network(
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) {
//                       return child; // Image is fully loaded
//                     }
//                     return const Center(
//                       child: CommonLoadingAnimation(), // Show the loading animation
//                     );
//                   },
//                   recommendationList.value[index].defaultProfilePic ?? '',
//                   // width: Dimens.margin225,
//                   height: Dimens.margin450,
//                   fit: BoxFit.cover,
//                 ),
//               )
//                   : ClipRRect(
//                 borderRadius: BorderRadius.circular(Dimens.margin30),
//                 child: SizedBox(
//                   height: Dimens.margin450,
//                   // width: 225,
//                   child: Image.asset(
//                     APPImages.icDummyProfile,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Container(
//                 height: Dimens.margin450,
//                 decoration: BoxDecoration(
//                     // image: DecorationImage(image: NetworkImage(recommendationList.value[index].profileImages?[0].imageUrl ?? ''), fit: BoxFit.cover),
//                     // color: Theme.of(context).primaryColor,
//                     borderRadius: BorderRadius.circular(Dimens.margin20)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             showCupertinoDialog(
//                               context: context,
//                               builder: (context) => CupertinoConfirmationDialog(
//                                 title: getTranslate(APPStrings.textReportUser),
//                                 description: getTranslate(APPStrings.textReportCnf),
//                                 cancelText: getTranslate(APPStrings.textCancel),
//                                 confirmText: getTranslate(APPStrings.textOk),
//                                 onCancel: () {
//                                   Navigator.pop(context);
//                                 },
//                                 onConfirm: () {
//                                   reportUser(recommendationList.value[index].userId ?? 0);
//                                   // Navigator.pop(context);
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                             );
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(25.0),
//                             child: Container(
//                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.margin100), color: Theme.of(context).colorScheme.primary),
//                                 height: Dimens.margin50,
//                                 width: Dimens.margin50,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: SvgPicture.asset(
//                                     APPImages.icFlagSvg,
//                                     color: Colors.white,
//                                   ),
//                                 )),
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             setState(() {
//                               // selectedUserId = modelRecommendations.value.data?[index].userId;
//                               selectedIndex = index;
//                               if (recommendationList.value[index].isFavourite ?? false) {
//                                 removeFromFavourite(recommendationList.value[index].userId ?? 0);
//                               } else {
//                                 addToFavourite(recommendationList.value[index].userId ?? 0);
//                               }
//                             });
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: Dimens.margin20),
//                             child: Container(
//                               decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.margin100), color: Theme.of(context).colorScheme.primary),
//                               height: Dimens.margin50,
//                               width: Dimens.margin50,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Image.asset(
//                                   APPImages.icStarPng,
//                                   color: (recommendationList.value[index].isFavourite ?? false) ? Colors.white : Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                             child: Text(
//                               recommendationList.value[index].username ?? '',
//                               style: getTextStyleFromFont(
//                                 shadow: <Shadow>[
//                                   const Shadow(
//                                     // offset: Offset(5.0, 5.0),
//                                     blurRadius: Dimens.margin20,
//                                     color: Color.fromARGB(255, 0, 0, 0),
//                                   ),
//                                 ],
//                                 AppFont.poppins,
//                                 Dimens.margin30,
//                                 Theme.of(context).primaryColor,
//                                 FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   showCupertinoDialog(
//                                     context: context,
//                                     builder: (context) => CupertinoConfirmationDialog(
//                                       title: "Remove User",
//                                       description: "Are you sure you want to remove this user?",
//                                       cancelText: "Cancel",
//                                       confirmText: "OK",
//                                       onCancel: () {
//                                         Navigator.pop(context);
//                                       },
//                                       onConfirm: () {
//                                         printWrapped("pressed key");
//                                         Navigator.pop(context);
//                                         selectedIndex = index;
//                                         removeUserFromDetails(recommendationList.value[index].userId ?? 0);
//                                       },
//                                     ),
//                                   );
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(25.0),
//                                   child: SizedBox(height: Dimens.margin60, width: Dimens.margin60, child: SvgPicture.asset(APPImages.icCross)),
//                                 ),
//                               ),
//                               Visibility(
//                                   visible: recommendationList.value[index].isConnected == false,
//                                   replacement: const SizedBox(),
//                                   child: InkWell(
//                                     onTap: () {
//                                       Navigator.pushNamed(context, AppRoutes.routesScreenSendRequest,
//                                               arguments: ModelRequestDataTransfer(toSendUserID: recommendationList.value[index].userId))
//                                           .then(
//                                         (value) {
//                                           if (value != null) {
//                                             ModelNavigationBackHandling model = value as ModelNavigationBackHandling;
//                                             setState(() {
//                                               if (model.isConnected != null) {
//                                                 recommendationList.value[selectedIndex ?? 0].isConnected = model.isConnected;
//                                               }
//                                             });
//                                             // getRecommendations(id: updatedRelatedInterest ?? 0);
//                                           }
//                                         },
//                                       );
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(25.0),
//                                       child: SizedBox(height: Dimens.margin60, width: Dimens.margin60, child: Image.asset(APPImages.icCennecButton)),
//                                     ),
//                                   ))
//                             ],
//                           ),
//                           // const SizedBox(
//                           //   height: Dimens.margin50,
//                           // )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         });
//   }
//
//   Widget getBody(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(height: Dimens.margin10),
//           navigationWithLogo(),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const SizedBox(height: Dimens.margin30),
//                   findConnectionsText(context),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     height: Dimens.margin450,
//                     child: connectionsCarousal(),
//                   ),
//                   const SizedBox(height: Dimens.margin55),
//                   goToDashboardButton(context),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiValueListenableBuilder(
//         valueListenables: [isLoading, modelRecommendation, recommendationList, currentIndex],
//         builder: (context, values, child) {
//           return MultiBlocListener(
//             listeners: [
//               BlocListener<GetRecommendationsBloc, GetRecommendationsState>(
//                 listener: (context, state) {
//                   isLoading.value = state is GetRecommendationsLoading;
//                   if (state is GetRecommendationsFailure) {}
//                   if (state is GetRecommendationsResponse) {
//                     if(state.modelRecommendations.pagination?.nextPageUrl != null)
//                     {
//                       modelRecommendation.value = state.modelRecommendations;
//                       containsMoreData = true;
//                       pageNumber++;
//                     }
//                     else
//                     {
//                       containsMoreData = false;
//                     }
//                     recommendationList.value.addAll((state.modelRecommendations.data ?? []).toList());
//                   }
//                 },
//               ),
//               BlocListener<FavouritesBloc, FavouritesState>(
//                 listener: (context, state) {
//                   isLoading.value = state is FavouritesLoading;
//                   if (state is FavouritesFailure) {
//                     if (state.errorMessage.generalError!.isNotEmpty) {
//                       ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
//                     }
//                   }
//                   if (state is FavouritesResponse) {
//                     printWrapped("in true");
//                     recommendationList.value[selectedIndex ?? 0].isFavourite = true;
//                     Navigator.pushNamed(context, AppRoutes.routesScreenFavourite,
//                             arguments: ModelRequestDataTransfer(toSendUserID: recommendationList.value[selectedIndex ?? 0].userId))
//                         .then(
//                       (value) {
//                         if (value != null && value == true) {
//                           // getRecommendations();
//                         }
//                       },
//                     ); // ToastController.showToast(context, state.modelSuccess.message ?? '', true);
//                   }
//                 },
//               ),
//               BlocListener<RemoveFromFavouriteBloc, RemoveFromFavouriteState>(
//                 listener: (context, state) {
//                   isLoading.value = state is RemoveFromFavouriteLoading;
//                   if (state is RemoveFromFavouriteFailure) {
//                     if (state.errorMessage.generalError!.isNotEmpty) {
//                       ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
//                     }
//                   }
//                   if (state is RemoveFromFavouriteResponse) {
//                     recommendationList.value[selectedIndex ?? 0].isFavourite = false;
//                     ToastController.showToast(context, state.modelSuccess.message ?? '', true);
//                   }
//                 },
//               ),
//               BlocListener<ReportUserBloc, ReportUserState>(
//                 listener: (context, state) {
//                   isLoading.value = state is ReportUserLoading;
//                   if (state is ReportUserFailure) {
//                     if (state.errorMessage.generalError!.isNotEmpty) {
//                       ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
//                     }
//                   }
//                   if (state is ReportUserResponse) {
//                     ToastController.showToast(context, state.modelReport.message ?? '', true);
//                   }
//                 },
//               ),
//               BlocListener<RemoveUserFromDetailsBloc, RemoveUserFromDetailsState>(
//                 listener: (context, state) {
//                   isLoading.value = state is RemoveUserFromDetailsLoading;
//                   if (state is RemoveUserFromDetailsFailure) {
//                     if (state.errorMessage.generalError!.isNotEmpty) {
//                       ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
//                     }
//                   }
//                   if (state is RemoveUserFromDetailsResponse) {
//                     recommendationList.value.removeAt(selectedIndex ?? 0);
//                     ToastController.showToast(context, state.modelSuccess.message ?? '', true);
//                     // getRecommendations();
//                   }
//                 },
//               ),
//             ],
//             child: Scaffold(
//               resizeToAvoidBottomInset: true,
//               backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//               body: IgnorePointer(
//                   ignoring: isLoading.value,
//                   child: Stack(
//                     children: [
//                       getBody(context),
//                       Visibility(
//                           visible: isLoading.value,
//                           child: const Center(
//                             child: CommonLoadingAnimation(),
//                           ))
//                     ],
//                   )),
//             ),
//           );
//         });
//   }
//
//   getRecommendation() {
//     BlocProvider.of<GetRecommendationsBloc>(context).add(GetRecommendations(url: "${AppUrls.apiGetRecommendation}?per_page=$perPage&page=$pageNumber"));
//   }
//
//   void addToFavourite(int toUserId) {
//     Map<String, dynamic> body = {
//       AppConfig.paramFavouriteBy: getUser().userData?.id ?? 0,
//       AppConfig.paramFavouriteTo: toUserId,
//     };
//
//     BlocProvider.of<FavouritesBloc>(context).add(AddToFavourites(url: AppUrls.apiAddToFavourites, body: body));
//   }
//
//   void removeFromFavourite(int friendId) {
//     BlocProvider.of<RemoveFromFavouriteBloc>(context).add(RemoveFromFavourite(url: AppUrls.apiRemoveFavourite(friendId)));
//   }
//
//   void reportUser(int toUserId) {
//     Map<String, dynamic> body = {
//       AppConfig.paramReportBy: getUser().userData?.id ?? 0,
//       AppConfig.paramReportTo: toUserId,
//     };
//     BlocProvider.of<ReportUserBloc>(context).add(ReportUser(url: AppUrls.apiReportUser, body: body));
//   }
//   void removeUserFromDetails(int userId) {
//     BlocProvider.of<RemoveUserFromDetailsBloc>(context).add(RemoveUserFromDetails(url: AppUrls.apiRemoveUser(userId)));
//   }
// }


import 'package:card_swiper/card_swiper.dart';
import 'package:cennec/modules/connections/bloc/removeFromFavourite/remove_from_favourite_bloc.dart';
import 'package:cennec/modules/connections/bloc/remove_user_from_details/remove_user_from_details_bloc.dart';
import 'package:cennec/modules/connections/model/model_recommendations.dart';
import 'package:cennec/modules/connections/model/model_send_request.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/preferences/bloc/report_user/report_user_bloc.dart';
import 'package:flutter/material.dart';
import '../../core/utils/common_import.dart';
import '../../interests/model/navigation_back_handling_model.dart';
import '../../search_posts/view/user_send_request_bottomsheet.dart';
import '../bloc/add_to_favourite/favourites_bloc.dart';
import '../bloc/get_recommendations/get_recommendations_bloc.dart';


class ScreenFindConnectionsSignup extends StatefulWidget {
  const ScreenFindConnectionsSignup({super.key});

  @override
  State<ScreenFindConnectionsSignup> createState() => _FindConnectionsSignupState();
}

class _FindConnectionsSignupState extends State<ScreenFindConnectionsSignup> {
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

  Widget buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 24,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Find Cennections',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24), // To balance the back button
        ],
      ),
    );
  }

  Widget buildUserCard(RecommendationData user, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row - Profile Image, Name, Star, Connect Button
          Row(
            children: [
              // Profile Image
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: user.defaultProfilePic != null
                    ? Image.network(
                  user.defaultProfilePic!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[200],
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  },
                )
                    : Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name
              Expanded(
                child: Text(
                  user.username ?? 'Unknown User',
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin16,
                    Colors.black,
                    FontWeight.w600,
                  ),
                ),
              ),

              // Star Icon
              InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    if (user.isFavourite ?? false) {
                      removeFromFavourite(user.userId ?? 0);
                    } else {
                      addToFavourite(user.userId ?? 0);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.star_border,
                    color: (user.isFavourite ?? false) ? Colors.orange : Colors.grey,
                    size: 20,
                  ),
                ),
              ),

              // Connect Button
              if (user.isConnected != true)
                InkWell(
                  onTap: () {
                    selectedIndex = index;
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.colorWhite,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.75,
                      ),
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (_) => BottomSheetConnectRequest(
                        modelRequestDataTransfer: ModelRequestDataTransfer(
                          isFromDashboard: true,
                          getUserId: getUser().userData?.id,
                          toSendUserID: user.userId,
                        ),
                      ),
                    );
                    // Navigator.pushNamed(
                    //   context,
                    //   AppRoutes.routesScreenSendRequest,
                    //   arguments: ModelRequestDataTransfer(toSendUserID: user.userId),
                    // ).then((value) {
                    //   if (value != null) {
                    //     ModelNavigationBackHandling model = value as ModelNavigationBackHandling;
                    //     setState(() {
                    //       if (model.isConnected != null) {
                    //         recommendationList.value[selectedIndex ?? 0].isConnected = model.isConnected;
                    //       }
                    //     });
                    //   }
                    // });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B3A52),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Cennec',
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        Dimens.margin12,
                        Colors.white,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Description
          if(user.bio?.isNotEmpty ?? false)
          Text(
            '${user.bio ?? ""}',
            style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin12,
              Colors.grey,
              FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // Interest Tags
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: (user.userInterests?.take(2).map((interest) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getInterestIcon(interest.interestName ?? ''),
                    size: 12,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '#${interest.interestName}',
                    style: getTextStyleFromFont(
                      AppFont.poppins,
                      Dimens.margin10,
                      Colors.grey[600]!,
                      FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )).toList()) ?? [],
          ),
        ],
      ),
    );
  }

  IconData _getInterestIcon(String interest) {
    switch (interest.toLowerCase()) {
      case 'art':
        return Icons.palette;
      case 'gaming':
        return Icons.games;
      case 'technology':
        return Icons.computer;
      case 'sports':
        return Icons.sports_football;
      case 'music':
        return Icons.music_note;
      default:
        return Icons.tag;
    }
  }

  Widget buildGoToDashboardButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.routesScreenDashboard,
                (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2B3A52),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Text(
          'Go to Dashboard',
          style: getTextStyleFromFont(
            AppFont.poppins,
            Dimens.margin16,
            Colors.white,
            FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
      valueListenables: [isLoading, modelRecommendation, recommendationList, currentIndex],
      builder: (context, values, child) {
        return MultiBlocListener(
          listeners: [
            BlocListener<GetRecommendationsBloc, GetRecommendationsState>(
              listener: (context, state) {
                isLoading.value = state is GetRecommendationsLoading;
                if (state is GetRecommendationsFailure) {}
                if (state is GetRecommendationsResponse) {
                  if (state.modelRecommendations.pagination?.nextPageUrl != null) {
                    modelRecommendation.value = state.modelRecommendations;
                    containsMoreData = true;
                    pageNumber++;
                  } else {
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
                  recommendationList.value[selectedIndex ?? 0].isFavourite = true;
                  ToastController.showToast(context, state.modelSuccess?.message?? "", true);
                  // Navigator.pushNamed(
                  //   context,
                  //   AppRoutes.routesScreenFavourite,
                  //   arguments: ModelRequestDataTransfer(toSendUserID: recommendationList.value[selectedIndex ?? 0].userId),
                  // ).then((value) {
                  //   if (value != null && value == true) {
                  //     // Handle return
                  //   }
                  // });
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
                }
              },
            ),
          ],
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: SafeArea(
              child: IgnorePointer(
                ignoring: isLoading.value,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        buildAppBar(),
                        Expanded(
                          child: recommendationList.value.isEmpty && !isLoading.value
                              ? const Center(
                            child: Text(
                              'No connections found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                              : ListView.builder(
                            padding: const EdgeInsets.only(top: 8, bottom: 80),
                            itemCount: recommendationList.value.length,
                            itemBuilder: (context, index) {
                              // Load more data when near the end
                              if (containsMoreData && index == recommendationList.value.length - 3) {
                                getRecommendation();
                              }
                              return GestureDetector(
                                onTap: () {
                                  selectedIndex = index;
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.routesScreenUserDetails,
                                    arguments: ModelRequestDataTransfer(
                                      getUserId: recommendationList.value[index].userId,
                                       isFromDashboard: false
                                    ),
                                  ).then((value) {
                                    if (value != null) {
                                      ModelNavigationBackHandling model = value as ModelNavigationBackHandling;
                                      setState(() {
                                        if (model.isFavourite != null) {
                                          recommendationList.value[selectedIndex ?? 0].isFavourite = model.isFavourite;
                                        }
                                        if (model.isRemoved != null && model.isRemoved == true) {
                                          recommendationList.value.removeAt(selectedIndex ?? 0);
                                        }
                                        if (model.isConnected != null) {
                                          recommendationList.value[selectedIndex ?? 0].isConnected = model.isConnected;
                                        }
                                      });
                                    }
                                  });
                                },
                                child: buildUserCard(recommendationList.value[index], index),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    // Bottom Button
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: const Color(0xFFF5F5F5),
                        child: buildGoToDashboardButton(),
                      ),
                    ),

                    // Loading Overlay
                    if (isLoading.value)
                      const Center(
                        child: CommonLoadingAnimation(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  getRecommendation() {
    BlocProvider.of<GetRecommendationsBloc>(context).add(
      GetRecommendations(url: "${AppUrls.apiGetRecommendation}?per_page=$perPage&page=$pageNumber"),
    );
  }

  void addToFavourite(int toUserId) {
    Map<String, dynamic> body = {
      AppConfig.paramFavouriteBy: getUser().userData?.id ?? 0,
      AppConfig.paramFavouriteTo: toUserId,
    };

    BlocProvider.of<FavouritesBloc>(context).add(
      AddToFavourites(url: AppUrls.apiAddToFavourites, body: body),
    );
  }

  void removeFromFavourite(int friendId) {
    BlocProvider.of<RemoveFromFavouriteBloc>(context).add(
      RemoveFromFavourite(url: AppUrls.apiRemoveFavourite(friendId)),
    );
  }

  void reportUser(int toUserId) {
    Map<String, dynamic> body = {
      AppConfig.paramReportBy: getUser().userData?.id ?? 0,
      AppConfig.paramReportTo: toUserId,
    };
    BlocProvider.of<ReportUserBloc>(context).add(
      ReportUser(url: AppUrls.apiReportUser, body: body),
    );
  }

  void removeUserFromDetails(int userId) {
    BlocProvider.of<RemoveUserFromDetailsBloc>(context).add(
      RemoveUserFromDetails(url: AppUrls.apiRemoveUser(userId)),
    );
  }
}
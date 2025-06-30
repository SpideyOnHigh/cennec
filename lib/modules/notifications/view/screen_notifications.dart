import 'package:cennec/modules/connections/bloc/accept-reject_requests/accept_reject_requests_bloc.dart';
import 'package:cennec/modules/connections/model/model_send_request.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/notifications/bloc/notifications_list_bloc.dart';
import 'package:cennec/modules/notifications/model/model_notification.dart';

import '../../core/common/widgets/toast_controller.dart';
import '../../core/utils/common_import.dart';

class ScreenNotifications extends StatefulWidget {
  const ScreenNotifications({super.key});

  @override
  State<ScreenNotifications> createState() => _ScreenNotificationsState();
}

class _ScreenNotificationsState extends State<ScreenNotifications> {
  @override
  void initState() {
    getNotification();
    super.initState();
  }

  List<NotificationData> notificationList = [];
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Widget navigationWithLogo() {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context,true);
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

  Widget searchForNewTitle(BuildContext context) {
    return Text(
      getTranslate(APPStrings.textCennectionRequests).toString(),
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin35,
        Theme.of(context).hintColor,
        FontWeight.w700,
      ),
    );
  }

  Widget noNewRequests(BuildContext context) {
    return Text(
      getTranslate(APPStrings.textNoRequests).toString(),
      // "No new cennection request.Go to the cennect page to send new requests.",
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin20,
        Theme.of(context).colorScheme.onSecondary,
        FontWeight.w600,
      ),
    );
  }

  Widget connectionRequest(NotificationData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            data.userProfileImage != null
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
                data.userProfileImage  ?? '',
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
                data.message ?? '',
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
                    takeAction(data, AppConfig.paramAccepted); //todo for connect
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
                InkWell(
                  onTap: () {
                    takeAction(data, AppConfig.paramRejected); //todo for ignore
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
                )
              ],
            )
          ],
        ),
        Visibility(
          visible:data.requestComment != null && (data.requestComment ?? '').isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data.requestComment ?? '',
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin18,
                Theme.of(context).colorScheme.onPrimary,
                FontWeight.w600,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget connectionConnected(NotificationData data) {
    //todo to manage in one
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            data.userProfileImage != null
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
                data.userProfileImage  ?? '',
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
                data.message ?? '',
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin18,
                  Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                  FontWeight.w600,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimens.margin10), color: AppColors.colorBlack1),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  getTranslate(APPStrings.textConnected),
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin12,
                    Theme.of(context).primaryColor,
                    FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
        Visibility(
          visible:data.requestComment != null && (data.requestComment ?? '').isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data.requestComment ?? '',
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin18,
                Theme.of(context).colorScheme.onPrimary,
                FontWeight.w600,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget notificationListWidget() {
    return ListView.builder(
      itemCount: notificationList.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (notificationList[index].type == 'connected') {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.routesScreenUserDetails,
                  arguments: ModelRequestDataTransfer(getUserId: notificationList[index].fromUserId,isFromDashboard: true));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: connectionConnected(notificationList[index]),
            ),
          );
        } else {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.routesScreenUserDetails,
                  arguments: ModelRequestDataTransfer(getUserId: notificationList[index].fromUserId,isFromDashboard: true));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: connectionRequest(notificationList[index]),
            ),
          );
        }
      },
    );
  }

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Dimens.margin20),
          navigationWithLogo(),
          const SizedBox(height: Dimens.margin20),
          searchForNewTitle(context),
          const SizedBox(height: Dimens.margin20),
          Visibility(visible: notificationList.isNotEmpty, replacement: noNewRequests(context), 
              child: Expanded(child: SingleChildScrollView(child: notificationListWidget()))),
          // noNewRequests(context),
          // const SizedBox(height: Dimens.margin20),
          // connectionRequest(),
          // const SizedBox(height: Dimens.margin20),
          // connectionConnected(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MultiValueListenableBuilder(
            valueListenables: [isLoading],
            builder: (context, values, child) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<NotificationsListBloc, NotificationsListState>(
                    listener: (context, state) {
                      isLoading.value = state is NotificationsListLoading;
                      if (state is NotificationsListFailure) {
                        if (state.errorMessage.generalError!.isNotEmpty) {
                          ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                        }
                      }
                      if (state is NotificationsListResponse) {
                        notificationList.clear();
                        notificationList.addAll(state.modelNotificationContent.data ?? []);
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
                        getNotification();
                      }
                    },
                  ),
                ],
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: Stack(
                    children: [
                      getBody(context),
                      Visibility(
                          visible: isLoading.value,
                          child: const Center(
                            child: CommonLoadingAnimation(),
                          ))
                    ],
                  ),
                ),
              );
            }));
  }

  getNotification() {
    BlocProvider.of<NotificationsListBloc>(context).add(NotificationsList(url: AppUrls.apiGetNotification));
  }

  takeAction(NotificationData data, String action) {
    Map<String, dynamic> body = {
      AppConfig.paramActionBy: getUser().userData?.id ?? 0,
      AppConfig.paramActionTo: data.fromUserId,
      AppConfig.paramRequestStatus: action,
      AppConfig.paramNotificationId: data.id
    };
    BlocProvider.of<AcceptRejectRequestsBloc>(context).add(AcceptRejectRequests(body: body, url: AppUrls.apiAcceptRejectRequests));
  }
}

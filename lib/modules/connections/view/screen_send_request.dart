import 'package:cennec/modules/connections/bloc/accept-reject_requests/accept_reject_requests_bloc.dart';
import 'package:cennec/modules/connections/bloc/fetch_user_bloc/fetch_user_details_bloc.dart';
import 'package:cennec/modules/connections/bloc/send_request_bloc/send_request_bloc.dart';
import 'package:cennec/modules/connections/model/model_fetch_user_detail.dart';
import 'package:cennec/modules/connections/model/model_send_request.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/common/widgets/dialog/common_loading_animation.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:cennec/modules/interests/model/model_interests.dart';
import 'package:cennec/modules/interests/model/navigation_back_handling_model.dart';

class ScreenSendRequest extends StatefulWidget {
  final ModelRequestDataTransfer modelRequestDataTransfer;
  const ScreenSendRequest({super.key, required this.modelRequestDataTransfer});

  @override
  State<ScreenSendRequest> createState() => _ScreenSendRequestState();
}

class _ScreenSendRequestState extends State<ScreenSendRequest> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isUpdating = ValueNotifier(false);
  ModelFetchUserDetail modelFetchUserDetail = ModelFetchUserDetail();
  ModelNavigationBackHandling modelNavigationBackHandling = ModelNavigationBackHandling();
  bool isAccepted = false;


  TextEditingController messageController = TextEditingController();

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
            Navigator.pop(context, modelNavigationBackHandling);
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

  Widget cennectionRequestsTitle(BuildContext context) {
    return Text(
      // getTranslate(APPStrings.textSelectInterests).toString(),
      "${getTranslate(APPStrings.textCennecWith)} ${modelFetchUserDetail.data?.username ?? ''}",
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin32,
        Theme.of(context).colorScheme.onSecondary,
        FontWeight.w600,
      ),
    );
  }

  Widget profileContainer(String name, String profilePicture) {
    return Column(
      children: [
        Container(
          width: Dimens.margin130,
          height: Dimens.margin170,
          decoration: BoxDecoration(
              // image: const DecorationImage(image: AssetImage(APPImages.icDummyProfile), fit: BoxFit.cover),
              // color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Dimens.margin30)),
          child: profilePicture.isNotEmpty
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
                    profilePicture,
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
        const SizedBox(
          height: Dimens.margin10,
        ),
        SizedBox(
          width: Dimens.margin120,
          child: Text(
            overflow: TextOverflow.ellipsis,
            // getTranslate(APPStrings.textSelectInterests).toString(),
            name,
            textAlign: TextAlign.center,
            style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin18,
              Theme.of(context).colorScheme.onSecondary,
              FontWeight.w600,
            ),
          ),
        )
      ],
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
      ),
    );
  }

  Widget interestNoText() {
    return Text(
      overflow: TextOverflow.ellipsis,
      // getTranslate(APPStrings.textSelectInterests).toString(),
      "${(modelFetchUserDetail.data?.mutualInterests ?? []).length} ${getTranslate(APPStrings.textMutualInts)}",
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin20,
        Theme.of(context).colorScheme.onSecondary,
        FontWeight.w600,
      ),
    );
  }

  Widget sendRequestButton() {
    return CommonButton(
      isLoading: isUpdating.value,
      text: modelFetchUserDetail.data?.isGotRequest == true
          ? 'Accept'
          : modelFetchUserDetail.data?.requestStatus == 0
              ? getTranslate(APPStrings.textSendRequest)
              : modelFetchUserDetail.data?.requestStatus == 1
                  ? "Requested"
                  : "Connected",
      backgroundColor: Theme.of(context).colorScheme.primary,
      onTap: () {
        if (modelFetchUserDetail.data?.requestStatus == 0 && modelFetchUserDetail.data?.isGotRequest == false ) {
          sendRequest();
        }
        if(modelFetchUserDetail.data?.isGotRequest == true)
          {
            takeAction();
          }
      },
    );
  }

  Widget sendMessageText() {
    return Text(
      overflow: TextOverflow.ellipsis,
      getTranslate(APPStrings.textSendMsg).toString(),
      // "Send a message",
      textAlign: TextAlign.center,
      style: getTextStyleFromFont(
        AppFont.poppins,
        Dimens.margin20,
        Theme.of(context).colorScheme.onSecondary,
        FontWeight.w600,
      ),
    );
  }

  Widget textFieldSendMessage() {
    return Container(
      height: Dimens.margin200,
      width: double.maxFinite,
      decoration: BoxDecoration(
        // color: Theme.of(context).primaryColor,
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
        borderRadius: BorderRadius.circular(Dimens.margin20),
      ),
      child: TextField(
        controller: messageController,
        minLines: 1,
        maxLines: 10,
        maxLength: 1000,
        onChanged: (value) {
          setState(() {});
        },
        inputFormatters: messageController.text.isEmpty ? [AlphanumericAndSpecialCharFormatter()] : null,
        style: getTextStyleFromFont(
          AppFont.poppins,
          Dimens.margin18,
          Theme.of(context).colorScheme.primary,
          FontWeight.w600,
        ), // Text color inside the TextField
        decoration: const InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.symmetric(horizontal: Dimens.margin20, vertical: 5), // Padding inside the TextField
          border: InputBorder.none, // Removes the border
        ),
      ),
    );
  }

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: Dimens.margin20),
        navigationWithLogo(),
        const SizedBox(height: Dimens.margin20),
        Center(child: cennectionRequestsTitle(context)),
        const SizedBox(height: Dimens.margin30),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // profileContainer(getUser().userData?.username ?? '',
                    profileContainer(
                      getUser().userData?.username ?? '',
                      getUser().userData?.defaultProfilePic ?? '',
                    ),
                    SizedBox(height: Dimens.margin30, width: Dimens.margin30, child: Image.asset(APPImages.icCennecBottom)),
                    // profileContainer(modelFetchUserDetail.data?.username ?? '',
                    //     (modelFetchUserDetail.data?.profileImages ?? []).isNotEmpty?
                    //     (modelFetchUserDetail.data?.profileImages ?? []).first.imageUrl ?? ''
                    //         : ''
                    profileContainer(modelFetchUserDetail.data?.username ?? '', modelFetchUserDetail.data?.defaultProfilePic ?? ''),
                  ],
                ),
                interestNoText(),
                interestGridview(),
                const SizedBox(height: Dimens.margin20),
                Visibility(
                    visible: modelFetchUserDetail.data?.requestStatus != 1 && (modelFetchUserDetail.data?.isGotRequest == false), child: sendMessageText()),
                const SizedBox(height: Dimens.margin20),
                Visibility(
                    visible: modelFetchUserDetail.data?.requestStatus != 1 && (modelFetchUserDetail.data?.isGotRequest == false),
                    child: textFieldSendMessage()),
                Visibility(
                    visible: (modelFetchUserDetail.data?.isGotRequest == true && (modelFetchUserDetail.data?.requestComment != null)),
                    child: Text(
                      "Message:- ${modelFetchUserDetail.data?.requestComment ?? ''}",
                      // "Send a message",
                      textAlign: TextAlign.center,
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        Dimens.margin20,
                        Theme.of(context).colorScheme.onSecondary,
                        FontWeight.w600,
                      ),
                    ))
              ],
            ),
          ),
        ),
        const SizedBox(height: Dimens.margin20),
        sendRequestButton(),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [isLoading, isUpdating],
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
              BlocListener<SendRequestBloc, SendRequestState>(
                listener: (context, state) {
                  isUpdating.value = state is SendRequestLoading;
                  if (state is SendRequestFailure) {
                    if (state.errorMessage.generalError!.isNotEmpty) {
                      ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                    }
                    if (state.errorMessage.requestComment != null) {
                      ToastController.showToast(context, state.errorMessage.requestComment ?? '', false);
                    }
                    if (state.errorMessage.alreadySent != null) {
                      ToastController.showToast(context, state.errorMessage.alreadySent ?? '', false);
                    }
                  }
                  if (state is SendRequestResponse) {
                    modelFetchUserDetail.data?.requestStatus == 1;
                    ToastController.showToast(context, state.modelSendRequestResponse.message ?? '', true);
                    Navigator.pop(context, true);
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
                    ToastController.showToast(context, state.modelRequestAction.message ?? '',true);
                    if(isAccepted)
                      {
                        modelNavigationBackHandling.isConnected = true;
                      }
                    Navigator.pop(context, modelNavigationBackHandling);
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
                  IgnorePointer(ignoring: isUpdating.value, child: getBody(context)),
                  Visibility(visible: isLoading.value, child: const Center(child: CommonLoadingAnimation()))
                ],
              ),
            )),
          );
        });
  }

  validate() {
    if (messageController.text.isEmpty) {
      ToastController.showToast(context, "", false);
    }
  }

  void fetchDetail() {
    BlocProvider.of<FetchUserDetailsBloc>(context).add(FetchUserDetails(url: AppUrls.apiFetchUserDetails(widget.modelRequestDataTransfer.toSendUserID ?? 0)));
  }

  void sendRequest() {
    Map<String, dynamic> body = {
      "from_user_id": getUser().userData?.id ?? '',
      "to_user_id": modelFetchUserDetail.data?.id,
      "request_comment": messageController.text.trim()
    };
    BlocProvider.of<SendRequestBloc>(context).add(SendRequest(body: body, url: AppUrls.apiSendRequest));
  }

  takeAction() {
    isAccepted = true;
    Map<String, dynamic> body = {
      AppConfig.paramActionBy: getUser().userData?.id ?? 0,
      AppConfig.paramActionTo: widget.modelRequestDataTransfer.toSendUserID,
      AppConfig.paramRequestStatus: AppConfig.paramAccepted,
    };
    BlocProvider.of<AcceptRejectRequestsBloc>(context).add(AcceptRejectRequests(body: body, url: AppUrls.apiAcceptRejectRequests));
  }
}

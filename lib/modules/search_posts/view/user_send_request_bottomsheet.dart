import 'package:cennec/modules/core/utils/my_print.dart';
import 'package:cennec/modules/search_posts/view/user_friend_confirmation_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:cennec/modules/core/utils/app_font.dart';
import 'package:cennec/modules/core/utils/app_images.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';

import '../../connections/bloc/fetch_user_bloc/fetch_user_details_bloc.dart';
import '../../connections/bloc/send_request_bloc/send_request_bloc.dart';
import '../../connections/model/model_fetch_user_detail.dart';
import '../../connections/model/model_send_request.dart';
import '../../core/api_service/common_service.dart';
import '../../core/common/widgets/dialog/common_loading_animation.dart';
import '../../core/common/widgets/toast_controller.dart';
import '../../core/utils/app_config.dart';
import '../../core/utils/app_urls.dart';
import '../../core/utils/common_import.dart';

// class BottomSheetConnectRequest extends StatelessWidget {
//   final String? currentUserImage;
//   final String? targetUserImage;
//   final String targetUserName;
//   final List<String> mutualInterests;
//   final String? currentUserName;
//   final String? message;
//
//   const BottomSheetConnectRequest({
//     super.key,
//     this.currentUserImage,
//     this.targetUserImage,
//     required this.targetUserName,
//     required this.mutualInterests,
//     this.message,
//     this.currentUserName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: MediaQuery.of(context).viewInsets, // handles keyboard overlap
//       child: Container(
//         height: MediaQuery.of(context).size.height * 0.75, // fixed height
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           color: AppColors.colorWhite,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildHeader(context),
//               const SizedBox(height: 20),
//               _buildAvatars(),
//               const SizedBox(height: 16),
//               _buildMutualInterests(),
//               const SizedBox(height: 16),
//               _buildMessageBox(context),
//               const SizedBox(height: 40),
//               CommonButton(
//                 text: "Send Request",
//                 height: 48,
//                 backgroundColor: AppColors.colorPrimary,
//                 onTap: () {
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     backgroundColor: Colors.transparent,
//                     builder: (_) => BottomSheetConnectionSent(
//                       currentUserImage: currentUserImage ?? '',
//                       targetUserImage: targetUserImage ?? '',
//                       targetUserName: targetUserName,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildHeader(BuildContext context) {
//     return Row(
//       children: [
//         IconButton(
//           icon: const Icon(Icons.arrow_back_ios, size: 18),
//           onPressed: () => Navigator.pop(context),
//         ),
//         const SizedBox(width: 4),
//         Expanded(
//           child: Text(
//             "Cennect with $targetUserName",
//             textAlign: TextAlign.center,
//             style: getTextStyleFromFont(
//               AppFont.poppins,
//               16,
//               AppColors.colorBlack,
//               FontWeight.w600,
//             ),
//           ),
//         ),
//         const Opacity(opacity: 0, child: Icon(Icons.arrow_back_ios)),
//       ],
//     );
//   }
//
//   Widget _buildAvatars() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildSafeAvatar(currentUserImage, currentUserName),
//             const SizedBox(width: 16),
//             _buildSafeAvatar(targetUserImage, targetUserName),
//           ],
//         ),
//         Container(
//           padding: const EdgeInsets.all(6),
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.white,
//             boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
//           ),
//           child: Image.asset(
//             APPImages.icCennecBottom,
//             width: 24,
//             height: 24,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSafeAvatar(String? imageUrl, String? userName) {
//     final hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;
//     final initials = (userName != null && userName.trim().isNotEmpty)
//         ? userName.trim()[0].toUpperCase()
//         : "?";
//
//     return CircleAvatar(
//       radius: 60,
//       backgroundColor:
//       hasImage ? AppColors.colorGreyExtraLight : AppColors.colorHyperLink,
//       backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
//       child: !hasImage
//           ? Text(
//         initials,
//         style: getTextStyleFromFont(
//           AppFont.poppins,
//           20,
//           AppColors.colorWhite,
//           FontWeight.w600,
//         ),
//       )
//           : null,
//     );
//   }
//
//   Widget _buildMutualInterests() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "${mutualInterests.length} Mutual Interests",
//           style: getTextStyleFromFont(
//             AppFont.poppins,
//             14,
//             AppColors.colorBlack,
//             FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Wrap(
//             alignment: WrapAlignment.start,
//             spacing: 8,
//             runSpacing: 8,
//             children: mutualInterests.map((label) {
//               return Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: AppColors.colorSelectedInterestChip,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   label,
//                   style: getTextStyleFromFont(
//                     AppFont.poppins,
//                     13,
//                     AppColors.colorBlack,
//                     FontWeight.w500,
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMessageBox(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 8),
//
//         Text(
//           "Send a Message",
//           style: getTextStyleFromFont(
//             AppFont.poppins,
//             14,
//             AppColors.colorBlack,
//             FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 8),
//
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           decoration: BoxDecoration(
//             color: AppColors.colorOffWhite,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: TextField(
//             maxLines: 4,
//             controller: TextEditingController(text: message ?? ''),
//             style: getTextStyleFromFont(
//               AppFont.poppins,
//               14,
//               AppColors.colorBlack1,
//               FontWeight.normal,
//             ),
//             decoration: const InputDecoration.collapsed(
//               hintText: "Send a Message...",
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
class BottomSheetConnectRequest extends StatefulWidget {
  final ModelRequestDataTransfer modelRequestDataTransfer;
  final void Function()? onPressed;

  const BottomSheetConnectRequest({
    super.key,
    required this.modelRequestDataTransfer,
    this.onPressed
  });

  @override
  State<BottomSheetConnectRequest> createState() => _BottomSheetConnectRequestState();
}

class _BottomSheetConnectRequestState extends State<BottomSheetConnectRequest> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  TextEditingController messageController = TextEditingController();
  ModelFetchUserDetail modelFetchUserDetail = ModelFetchUserDetail();

  @override
  void initState() {
    super.initState();
    fetchUserDetail();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void fetchUserDetail() {
    BlocProvider.of<FetchUserDetailsBloc>(context).add(
        FetchUserDetails(
            url: AppUrls.apiFetchUserDetails(widget.modelRequestDataTransfer.toSendUserID ?? 0)
        )
    );
  }

  void sendConnectionRequest() {
    Map<String, dynamic> body = {
      AppConfig.paramFromUserId: getUser().userData?.id ?? 0,
      "to_user_id": widget.modelRequestDataTransfer.toSendUserID ?? 0,
      "message": messageController.text.trim(),
    };

    BlocProvider.of<SendRequestBloc>(context).add(
        SendRequest(url: AppUrls.apiSendRequest, body: body)
    );
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, loading, child) {
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
                }
              },
            ),
            BlocListener<SendRequestBloc, SendRequestState>(
              listener: (context, state) {
                isLoading.value = state is SendRequestLoading;
                MyPrint.printOnConsole("State:: ${state}");
                if (state is SendRequestFailure) {
                  if (state.errorMessage.generalError!.isNotEmpty) {
                    ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                  } else if(state.errorMessage.alreadySent?.isNotEmpty ?? false){
                    ToastController.showToast(context, state.errorMessage.alreadySent ?? 'Request sent successfully!', true);
                  }
                }
                if (state is SendRequestResponse) {
                  MyPrint.printOnConsole("Send request response : ${state.modelSendRequestResponse.toJson()}");
                    ToastController.showToast(context, state.modelSendRequestResponse.message ?? 'Request sent successfully!', true);
                    showModalBottomSheet(

                      context: context,
                      isScrollControlled: true,
                      constraints: BoxConstraints(
                        minHeight:  MediaQuery.of(context).size.height * 0.75,
                      ),
                      backgroundColor: AppColors.colorWhite,
                      builder: (_) => BottomSheetConnectionSent(
                        currentUserImage: getUser().userData?.defaultProfilePic ?? '',
                        targetUserImage: modelFetchUserDetail.data?.defaultProfilePic ?? '',
                        targetUserName: modelFetchUserDetail.data?.username ?? '',
                      ),
                    );

                }
              },
            ),
          ],
          child: Container(
            constraints:  BoxConstraints(maxHeight: MediaQuery.of(context).size.height*.75),
            child: Stack(
              children: [
                IgnorePointer(
                  ignoring: loading,
                  child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                      // height: MediaQuery.of(context).size.height * 0.75,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppColors.colorWhite,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: 20),
                          _buildAvatars(),
                          const SizedBox(height: 16),
                          _buildMutualInterests(),
                          const SizedBox(height: 16),
                          _buildMessageBox(context),
                          const SizedBox(height: 40),
                          CommonButton(
                            text: "Send Request",
                            height: 48,
                            backgroundColor: AppColors.colorPrimary,
                            onTap: () async {
                              sendConnectionRequest();

                            },
                            // onTap: sendConnectionRequest,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (loading)
                  const Center(
                    child: CommonLoadingAnimation(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: widget.onPressed ?? () => Navigator.pop(context),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            "Cennect with ${modelFetchUserDetail.data?.username ?? ''}",
            textAlign: TextAlign.center,
            style: getTextStyleFromFont(
              AppFont.poppins,
              16,
              AppColors.colorBlack,
              FontWeight.w600,
            ),
          ),
        ),
        const Opacity(opacity: 0, child: Icon(Icons.arrow_back_ios)),
      ],
    );
  }

  Widget _buildAvatars() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSafeAvatar(
              getUser().userData?.defaultProfilePic,
              getUser().userData?.username,
            ),
            const SizedBox(width: 16),
            _buildSafeAvatar(
              modelFetchUserDetail.data?.defaultProfilePic,
              modelFetchUserDetail.data?.username,
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Image.asset(
            APPImages.icCennecBottom,
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSafeAvatar(String? imageUrl, String? userName) {
    final hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;
    final initials = (userName != null && userName.trim().isNotEmpty)
        ? userName.trim()[0].toUpperCase()
        : "?";

    return CircleAvatar(
      radius: 60,
      backgroundColor:
      hasImage ? AppColors.colorGreyExtraLight : AppColors.colorHyperLink,
      backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
      child: !hasImage
          ? Text(
        initials,
        style: getTextStyleFromFont(
          AppFont.poppins,
          20,
          AppColors.colorWhite,
          FontWeight.w600,
        ),
      )
          : null,
    );
  }

  Widget _buildMutualInterests() {
    final mutualInterests = modelFetchUserDetail.data?.mutualInterests ?? [];
    final interestNames = mutualInterests.map((interest) => interest.interestName ?? '').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${interestNames.length} Mutual Interests",
          style: getTextStyleFromFont(
            AppFont.poppins,
            14,
            AppColors.colorBlack,
            FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            children: interestNames.map((label) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.colorSelectedInterestChip,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    13,
                    AppColors.colorBlack,
                    FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          "Send a Message",
          style: getTextStyleFromFont(
            AppFont.poppins,
            14,
            AppColors.colorBlack,
            FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.colorOffWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            maxLines: 4,
            controller: messageController,
            style: getTextStyleFromFont(
              AppFont.poppins,
              14,
              AppColors.colorBlack1,
              FontWeight.normal,
            ),
            decoration: const InputDecoration.collapsed(
              hintText: "Send a Message...",
            ),
          ),
        ),
      ],
    );
  }
}
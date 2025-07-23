import 'package:cennec/modules/search_posts/model/similar_post_model.dart';
import 'package:cennec/modules/search_posts/view/user_profile_bottomsheet.dart';
import 'package:cennec/modules/search_posts/view/user_send_request_bottomsheet.dart';
import 'package:cennec/modules/core/utils/common_import.dart';

import '../../connections/model/model_send_request.dart';

class SimilarPostsCard extends StatefulWidget {
  final String userName;
  final String? userImage;
  final int mutualConnections;
  final int matchPercentage;
  final String title;
  final String description;
  final List<String> interests;
  final bool isFriend; // Determines button state
  final SimilarPostData? similarPostData;

  const SimilarPostsCard({
    super.key,
    required this.userName,
    this.userImage,
    required this.mutualConnections,
    required this.matchPercentage,
    required this.title,
    required this.description,
    required this.interests,
    required this.isFriend,
    this.similarPostData
  });

  @override
  State<SimilarPostsCard> createState() => _SimilarPostsCardState();
}

class _SimilarPostsCardState extends State<SimilarPostsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.colorWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
            backgroundColor: AppColors.colorWhite,
            builder: (_) => UserProfileBottomSheet(
              userName: widget.userName ?? "Unknown User",
              userImage: widget.similarPostData?.userInfo?.defaultProfilePicture ?? "",
              mutualConnections:  widget.similarPostData?.mutualConnection ?? 0,
              matchPercentage: widget.matchPercentage ?? 0,
              title:  widget.similarPostData?.discussionTopic ?? "",
              description: widget.description ?? "",
              interests: widget.similarPostData?.userInterest?.map((interest) => interest.interestName ?? "").toList() ?? [],
              isFriend: widget.isFriend ?? false,
              similarPostData: widget.similarPostData,),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopRow(context),
            const SizedBox(height: 12),
            const Divider(),
            _buildTitle(),
            _buildDescription(),
            const SizedBox(height: 12),
            _buildInterestChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.colorGrey,
          backgroundImage: (widget.userImage != null && widget.userImage!.isNotEmpty) ? NetworkImage(widget.userImage!) : null,
          child: (widget.userImage == null || widget.userImage!.isEmpty)
              ? Text(
                  widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : "?",
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    16,
                    AppColors.colorWhite,
                    FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.userName,
                    style: getTextStyleFromFont(
                      AppFont.poppins,
                      16,
                      AppColors.colorBlack,
                      FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.bgPercentChipLightColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${widget.matchPercentage}%",
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        12,
                        AppColors.colorHyperLink,
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                "${widget.mutualConnections} mutual connections",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  13,
                  AppColors.colorGrey,
                  FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        _buildFriendIcon(widget.isFriend),
      ],
    );
  }

  Widget _buildTitle() {
    if( widget.title.isEmpty)return SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        widget.title,
        style: getTextStyleFromFont(
          AppFont.poppins,
          15,
          AppColors.colorBlack,
          FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    if( widget.description.isEmpty) return SizedBox();
    return Text(
      widget.description,
      style: getTextStyleFromFont(
        AppFont.poppins,
        13,
        AppColors.colorBlack1,
        FontWeight.w400,
      ).copyWith(height: 1.4),
    );
  }

  // Widget _buildInterestChips() {
  //   return Wrap(
  //     spacing: 8,
  //     runSpacing: 8,
  //     children: widget.interests.map((label) => _interestChip(label)).toList(),
  //   );
  // }

  bool _showAllChips = false;

  Widget _buildInterestChips() {
    List<UserInterest> chipsToShow = _showAllChips
        ? widget.similarPostData!.userInterest!
        : widget.similarPostData!.userInterest!.take(3).toList();

    List<Widget> chips = chipsToShow
        .map((label) => _interestChip(label.interestName ?? "", label.interestMatch ?? false ))
        .toList();

    if (widget.interests.length > 3) {
      chips.add(
        _viewMore(_showAllChips ? 'View Less' : 'View More'),
      );
    }

    return Wrap(
      runAlignment: WrapAlignment.center,
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 8,
      children: chips,
    );
  }

  Widget _viewMore(String text,){
    return Text(text,style: TextStyle(decoration: TextDecoration.underline, fontSize: 15, color: Colors.blue, decorationColor: Colors.blue),);
  }

  Widget _interestChip(String label, bool isMatch) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isMatch ? AppColors.colorSelectedInterestChip : AppColors.colorSelectedInterestChip.withOpacity(.2),
        border: Border.all(color: AppColors.colorGreyExtraLight),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Text("🎯 ", style: TextStyle(fontSize: 14)),
          Text(
            label,
            style: getTextStyleFromFont(
              AppFont.poppins,
              13,
              AppColors.colorBlack,
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendIcon(bool isFriend) {
    return InkWell(
      onTap: (){
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.colorWhite,
          constraints: BoxConstraints(
            maxHeight:  MediaQuery.of(context).size.height * 0.75,
          ),
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (_) => BottomSheetConnectRequest(
            modelRequestDataTransfer: ModelRequestDataTransfer(
              isFromDashboard: true,
              getUserId: getUser().userData?.id,
              toSendUserID: widget.similarPostData?.userId,
            ),
          ),
        );
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isFriend ? AppColors.colorWhite : AppColors.colorHyperLink,
          border: Border.all(
            color: AppColors.colorHyperLink,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: AppColors.colorBlackTransparent,
              blurRadius: 2,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Icon(
          isFriend ? Icons.chat_bubble_outline : Icons.person_add_alt_1,
          size: 20,
          color: isFriend ? AppColors.colorHyperLink : AppColors.colorWhite,
        ),
      ),
    );
  }
}

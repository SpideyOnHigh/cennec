import 'package:cennec/modules/search_posts/view/user_profile_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:cennec/modules/core/utils/app_font.dart';
import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:cennec/modules/core/utils/app_dimens.dart';
import 'package:cennec/modules/core/utils/common_import.dart';

class SimilarPostsCard extends StatelessWidget {
  final String userName;
  final String? userImage;
  final int mutualConnections;
  final int matchPercentage;
  final String title;
  final String description;
  final List<String> interests;
  final bool isFriend; // Determines button state

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
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(context),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          _buildTitle(),
          const SizedBox(height: 8),
          _buildDescription(),
          const SizedBox(height: 12),
          _buildInterestChips(),
        ],
      ),
    );
  }

  Widget _buildTopRow(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              backgroundColor: AppColors.colorWhite,
              builder: (_) => const UserProfileBottomSheet(),
            );
          },

          child: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.colorGrey,
            backgroundImage: (userImage != null && userImage!.isNotEmpty)
                ? NetworkImage(userImage!)
                : null,
            child: (userImage == null || userImage!.isEmpty)
                ? Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : "?",
              style: getTextStyleFromFont(
                AppFont.poppins,
                16,
                AppColors.colorWhite,
                FontWeight.bold,
              ),
            )
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    userName,
                    style: getTextStyleFromFont(
                      AppFont.poppins,
                      16,
                      AppColors.colorBlack,
                      FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.bgPercentChipLightColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "$matchPercentage%",
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
                "$mutualConnections mutual connections",
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
        _buildFriendIcon(isFriend),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: getTextStyleFromFont(
        AppFont.poppins,
        15,
        AppColors.colorBlack,
        FontWeight.w600,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      description,
      style: getTextStyleFromFont(
        AppFont.poppins,
        13,
        AppColors.colorBlack1,
        FontWeight.w400,
      ).copyWith(height: 1.4),
    );
  }

  Widget _buildInterestChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: interests.map((label) => _interestChip(label)).toList(),
    );
  }

  Widget _interestChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.colorSelectedInterestChip,
        border: Border.all(color: AppColors.colorGreyExtraLight),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("🎯 ", style: TextStyle(fontSize: 14)),
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
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isFriend ? AppColors.colorWhite : AppColors.colorHyperLink,
        border: Border.all(
          color: AppColors.colorHyperLink,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorBlackTransparent,
            blurRadius: 2,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Icon(
        isFriend ? Icons.chat_bubble_outline : Icons.person_add_alt_1,
        size: 20,
        color: AppColors.colorHyperLink,
      ),
    );
  }
}

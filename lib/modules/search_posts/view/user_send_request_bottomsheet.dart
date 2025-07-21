import 'package:cennec/modules/search_posts/view/user_friend_confirmation_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:cennec/modules/core/utils/app_font.dart';
import 'package:cennec/modules/core/utils/app_images.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';

import '../../core/api_service/common_service.dart';

class BottomSheetConnectRequest extends StatelessWidget {
  final String? currentUserImage;
  final String? targetUserImage;
  final String targetUserName;
  final List<String> mutualInterests;
  final String? currentUserName;
  final String? message;

  const BottomSheetConnectRequest({
    super.key,
    this.currentUserImage,
    this.targetUserImage,
    required this.targetUserName,
    required this.mutualInterests,
    this.message,
    this.currentUserName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // handles keyboard overlap
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75, // fixed height
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.colorWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
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
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BottomSheetConnectionSent(
                      currentUserImage: currentUserImage ?? '',
                      targetUserImage: targetUserImage ?? '',
                      targetUserName: targetUserName,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            "Cennect with $targetUserName",
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
            _buildSafeAvatar(currentUserImage, currentUserName),
            const SizedBox(width: 16),
            _buildSafeAvatar(targetUserImage, targetUserName),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${mutualInterests.length} Mutual Interests",
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
            children: mutualInterests.map((label) {
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
            controller: TextEditingController(text: message ?? ''),
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

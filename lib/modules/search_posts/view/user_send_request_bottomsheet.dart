import 'package:flutter/material.dart';
import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:cennec/modules/core/utils/app_font.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';

class BottomSheetConnectRequest extends StatelessWidget {
  final String currentUserImage;
  final String targetUserImage;
  final String targetUserName;
  final List<String> mutualInterests;
  final String message;

  const BottomSheetConnectRequest({
    super.key,
    required this.currentUserImage,
    required this.targetUserImage,
    required this.targetUserName,
    required this.mutualInterests,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.colorWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
          _buildMessageBox(),
          const SizedBox(height: 20),
          CommonButton(
            text: "Send Request",
            height: 48,
            backgroundColor: AppColors.colorPrimary,
            onTap: () {
              Navigator.pop(context);
              // Handle send action
            },
          ),
        ],
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
            style: TextStyle(
              fontFamily: AppFont.poppins,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.colorBlack,
            ),
          ),
        ),
        const Opacity(opacity: 0, child: Icon(Icons.arrow_back_ios)), // Dummy for symmetry
      ],
    );
  }

  Widget _buildAvatars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 36,
          backgroundImage: NetworkImage(currentUserImage),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Image.asset(
            'assets/images/logo.png', // Your app logo or connection icon
            width: 24,
            height: 24,
          ),
        ),
        CircleAvatar(
          radius: 36,
          backgroundImage: NetworkImage(targetUserImage),
        ),
      ],
    );
  }

  Widget _buildMutualInterests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${mutualInterests.length} Mutual Interests",
          style: TextStyle(
            fontFamily: AppFont.poppins,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.colorBlack,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: mutualInterests.map((label) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.colorSelectedInterestChip,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: AppFont.poppins,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.colorBlack,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMessageBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.colorOffWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontFamily: AppFont.poppins,
          fontSize: 14,
          color: AppColors.colorBlack1,
          height: 1.4,
        ),
      ),
    );
  }
}

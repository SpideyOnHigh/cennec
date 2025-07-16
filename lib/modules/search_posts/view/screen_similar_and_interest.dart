import 'package:flutter/material.dart';
import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:cennec/modules/core/utils/app_font.dart';
import 'package:cennec/modules/core/utils/app_dimens.dart';
import 'package:cennec/modules/search_posts/view/similar_interest_tab.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/utils/common_import.dart';

class ScreenSimilarAndInterest extends StatelessWidget {
  const ScreenSimilarAndInterest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorRoundedBgContainer,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.colorGrey,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Cennect",
          style: getTextStyleFromFont(
            AppFont.poppins,
            18,
            AppColors.colorBlack,
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: AppColors.colorWhite,
      ),

      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    return Column(
      children: [
        _buildUserPostCard(context),
        const Expanded(child: SimilarInterestTabs()),
      ],
    );
  }

  Widget _buildUserPostCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.colorWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.colorGreyExtraLight,
                backgroundImage: const AssetImage('assets/images/sample_profile.png'),
                onBackgroundImageError: (_, __) {},
                child: Text(
                  'A',
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    16,
                    AppColors.colorWhite,
                    FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "I want to go on a hike near Seattle at night with expert Hikers for a sense of adventure",
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    15,
                    AppColors.colorBlack,
                    FontWeight.w500,
                  ).copyWith(height: 1.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          CommonButton(
            text: "Post Publicly",
            backgroundColor: AppColors.colorPrimary,
            height: 48,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

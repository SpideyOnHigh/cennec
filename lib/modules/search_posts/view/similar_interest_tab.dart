import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:cennec/modules/search_posts/view/similar_post_card.dart';
import 'package:flutter/material.dart';

import '../../core/utils/app_font.dart';

class SimilarInterestTabs extends StatefulWidget {
  const SimilarInterestTabs({super.key});

  @override
  State<SimilarInterestTabs> createState() => _SimilarInterestTabsState();
}

class _SimilarInterestTabsState extends State<SimilarInterestTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = ["Similar Posts", "Interest Matches"];

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16,right: 16),
          child: Container(
            color: Colors.transparent,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.colorHyperLink,
              unselectedLabelColor: AppColors.colorGreyLight1,
              labelStyle: const TextStyle(
                fontFamily: AppFont.poppins,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: AppFont.poppins,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              indicatorColor: AppColors.colorHyperLink,
              indicatorWeight: 3,
              indicatorPadding: const EdgeInsets.only(left: 4, right: 4),
              tabs: tabs.map((e) => Tab(text: e)).toList(),
            ),
          )

        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Similar Posts
              ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: 1,
                itemBuilder: (_, index) =>const SimilarPostsCard(
                  userName: "Test User",
                  userImage: "https://yourbaseurl.com/user_profile_images/66e825745ac82.jpg",
                  mutualConnections: 21,
                  matchPercentage: 95,
                  title: "I wanna hike this Friday to get back in shape",
                  description: "Experienced professional with a demonstrated history of working in the apparel, film, art, music",
                  interests: [
                    "Sports Events & News",
                    "Destinations & Attractions",
                    "Label",
                  ], isFriend: true,
                )

              ),

              // Tab 2: Interest Matches (Placeholder for now)
              const Center(child: Text("Interest Matches coming soon...")),
            ],
          ),
        ),
      ],
    );
  }
}

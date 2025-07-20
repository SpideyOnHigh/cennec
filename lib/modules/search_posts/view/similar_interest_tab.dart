import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:cennec/modules/search_posts/view/similar_post_card.dart';
import 'package:cennec/modules/search_posts/model/similar_post_model.dart';
import 'package:flutter/material.dart';

import '../../core/utils/app_font.dart';

class SimilarInterestTabs extends StatefulWidget {
  final List<SimilarPostData> similarPosts;
  final List<SimilarPostData> interestMatches; // New parameter for interest matches
  final VoidCallback? onLoadMoreSimilar;
  final VoidCallback? onLoadMoreInterest; // New callback for interest matches
  final VoidCallback? onRefresh;
  final bool isLoadingMoreSimilar;
  final bool isLoadingMoreInterest; // New loading state for interest matches
  final bool hasMoreSimilarData;
  final bool hasMoreInterestData; // New parameter for interest matches
  final bool isInterestLoading; // Loading state for interest tab

  const SimilarInterestTabs({
    super.key,
    this.similarPosts = const [],
    this.interestMatches = const [], // Initialize interest matches
    this.onLoadMoreSimilar,
    this.onLoadMoreInterest, // New callback
    this.onRefresh,
    this.isLoadingMoreSimilar = false,
    this.isLoadingMoreInterest = false, // New loading state
    this.hasMoreSimilarData = true,
    this.hasMoreInterestData = true, // New parameter
    this.isInterestLoading = false, // New loading state
  });

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

  Widget _buildSimilarPostsTab() {
    // Check if we have similar posts data
    if (widget.similarPosts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.colorGreyLight1,
            ),
            SizedBox(height: 16),
            Text(
              "No similar posts found",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.colorGreyLight1,
                fontFamily: AppFont.poppins,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh?.call();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget.similarPosts.length + (widget.hasMoreSimilarData ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the end for pagination
          if (index == widget.similarPosts.length) {
            if (widget.isLoadingMoreSimilar) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (widget.hasMoreSimilarData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: widget.onLoadMoreSimilar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Load More',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFont.poppins,
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          final post = widget.similarPosts[index];

          return SimilarPostsCard(
            similarPostData: post,
            userName: post.userName ?? "Unknown User",
            userImage: post.userInfo?.defaultProfilePicture ?? "",
            mutualConnections: post.mutualConnection ?? 0,
            matchPercentage: post.matchPercentage ?? 0,
            title: post.discussionTopic ?? "",
            description: post.description ?? "",
            interests: post.userInterest?.map((interest) => interest.interestName ?? "").toList() ?? [],
            isFriend: post.isFriend ?? false,
          );
        },
      ),
    );
  }

  Widget _buildInterestMatchesTab() {
    // Show loading for initial load
    if (widget.isInterestLoading && widget.interestMatches.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Loading interest matches...",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.colorGreyLight1,
                fontFamily: AppFont.poppins,
              ),
            ),
          ],
        ),
      );
    }

    // Check if we have interest matches data
    if (widget.interestMatches.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: AppColors.colorGreyLight1,
            ),
            SizedBox(height: 16),
            Text(
              "No interest matches found",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.colorGreyLight1,
                fontFamily: AppFont.poppins,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh?.call();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget.interestMatches.length + (widget.hasMoreInterestData ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the end for pagination
          if (index == widget.interestMatches.length) {
            if (widget.isLoadingMoreInterest) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (widget.hasMoreInterestData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: widget.onLoadMoreInterest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Load More',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFont.poppins,
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          final post = widget.interestMatches[index];

          return SimilarPostsCard(
            similarPostData: post,
            userName: post.userName ?? "Unknown User",
            userImage: post.userInfo?.defaultProfilePicture ?? "",
            mutualConnections: post.mutualConnection ?? 0,
            matchPercentage: post.matchPercentage ?? 0,
            title: post.discussionTopic ?? "",
            description: post.description ?? "",
            interests: post.userInterest?.map((interest) => interest.interestName ?? "").toList() ?? [],
            isFriend: post.isFriend ?? false,
          );
        },
      ),
    );
  }

  void _handleConnect(int? userId) {
    if (userId != null) {
      // Handle connect action
      // You can add another bloc call for connecting with user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connect request sent to user $userId")),
      );
    }
  }

  void _handleViewProfile(int? userId) {
    if (userId != null) {
      // Handle view profile action
      // Navigate to user profile screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Viewing profile of user $userId")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
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
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Similar Posts
              _buildSimilarPostsTab(),
              // Tab 2: Interest Matches
              _buildInterestMatchesTab(),
            ],
          ),
        ),
      ],
    );
  }
}
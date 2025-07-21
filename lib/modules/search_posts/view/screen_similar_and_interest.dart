import 'package:cennec/modules/search_posts/model/similar_post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:cennec/modules/core/utils/app_font.dart';
import 'package:cennec/modules/search_posts/view/similar_interest_tab.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';

import '../bloc/get_interest_match_post/get_interest_post_bloc.dart';
import '../bloc/get_similar_post/get_similar_post_bloc.dart';
import '../bloc/user_add_post/add_user_post_bloc.dart';

class ScreenSimilarAndInterest extends StatefulWidget {
  final String searchText;
  final String location;
  final String meetAt;
  final String meetWith;
  final String discussionTopic;
  final String activity;

  const ScreenSimilarAndInterest(
      {super.key,
      this.searchText = "",
      this.location = "",
      this.meetAt = "",
      this.discussionTopic = "",
      this.meetWith = "",
      this.activity = ""});

  @override
  State<ScreenSimilarAndInterest> createState() => _ScreenSimilarAndInterestState();
}

class _ScreenSimilarAndInterestState extends State<ScreenSimilarAndInterest> {
  // ValueNotifiers for state management
  final ValueNotifier<bool> isPostLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isApiLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoadingMoreSimilar = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoadingMoreInterest = ValueNotifier<bool>(false);
  final ValueNotifier<bool> hasMoreSimilarData = ValueNotifier<bool>(true);
  final ValueNotifier<bool> hasMoreInterestData = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isInterestLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isPubliclyPostDone = ValueNotifier<bool>(false);
  final ValueNotifier<List<SimilarPostData>> allSimilarPosts = ValueNotifier<List<SimilarPostData>>([]);
  final ValueNotifier<List<SimilarPostData>> allInterestMatches = ValueNotifier<List<SimilarPostData>>([]);

  // Pagination variables
  int currentSimilarPage = 0;
  int currentInterestPage = 0;
  final int pageSize = 5;

  // Search parameters - you can make these dynamic based on user input
  String activity = "";
  String location = "Vadodara";
  String meetAt = "";
  String meetWith = "";
  String discussionTopic = "Box Cricket";
  String description = "Box Cricket";

  @override
  void initState() {
    super.initState();
    description = "${widget.searchText}";
    activity = widget.activity;
    location = widget.location;
    meetAt = widget.meetAt;
    meetWith = widget.meetWith;
    discussionTopic = widget.discussionTopic;
    _fetchSimilarPosts(isFirstLoad: true);
    _fetchInterestMatches(isFirstLoad: true);
  }

  // Similar Posts Methods
  void _fetchSimilarPosts({bool isFirstLoad = false, bool isLoadMore = false}) {
    if (isLoadMore) {
      isLoadingMoreSimilar.value = true;
    } else if (isFirstLoad) {
      isApiLoading.value = true;
    }

    // Create the pagination body
    Map<String, dynamic> body = {
      "skip": isLoadMore ? (currentSimilarPage * pageSize).toString() : "0",
      "take": pageSize.toString(),
      "activity": activity,
      "location": location,
      "meet_at": meetAt,
      "meet_with": meetWith,
      "discussion_topic": discussionTopic,
    };

    BlocProvider.of<GetSimilarPostsBloc>(context).add(
      GetSimilarPosts(
        url: AppUrls.apiGetSimilarPost,
        body: body,
      ),
    );
  }

  void _loadMoreSimilarPosts() {
    if (!isLoadingMoreSimilar.value && hasMoreSimilarData.value) {
      currentSimilarPage++;
      _fetchSimilarPosts(isLoadMore: true);
    }
  }

  // Interest Matches Methods
  void _fetchInterestMatches({bool isFirstLoad = false, bool isLoadMore = false}) {
    if (isLoadMore) {
      isLoadingMoreInterest.value = true;
    } else if (isFirstLoad) {
      isInterestLoading.value = true;
    }

    // Create the pagination body for interest matches
    Map<String, dynamic> body = {
      "skip": isLoadMore ? (currentInterestPage * pageSize).toString() : "0",
      "take": pageSize.toString(),
      "activity": activity,
      "location": location,
      "meet_at": meetAt,
      "meet_with": meetWith,
      "discussion_topic": discussionTopic,
    };

    BlocProvider.of<GetInterestMatchesBloc>(context).add(
      GetInterestMatches(
        url: AppUrls.apiGetInterestMatchPost,
        body: body,
      ),
    );
  }

  void _loadMoreInterestMatches() {
    if (!isLoadingMoreInterest.value && hasMoreInterestData.value) {
      currentInterestPage++;
      _fetchInterestMatches(isLoadMore: true);
    }
  }

  void _refreshPosts() {
    // Reset Similar Posts
    allSimilarPosts.value = [];
    currentSimilarPage = 0;
    hasMoreSimilarData.value = true;
    isLoadingMoreSimilar.value = false;

    // Reset Interest Matches
    allInterestMatches.value = [];
    currentInterestPage = 0;
    hasMoreInterestData.value = true;
    isLoadingMoreInterest.value = false;
    isInterestLoading.value = false;

    _fetchSimilarPosts(isFirstLoad: true);
    _fetchInterestMatches(isFirstLoad: true);
  }

  void _postPublicly() {
    if (isPostLoading.value) return;

    // Create the body for add user post API
    Map<String, dynamic> body = {
      "activity": activity,
      "location": location,
      "meet_at": meetAt,
      "meet_with": meetWith,
      "discussion_topic": discussionTopic,
      "description": description,
    };

    // Trigger the add user post bloc event
    BlocProvider.of<AddUserPostBloc>(context).add(
      AddUserPost(
        url: AppUrls.apiAddPost, // You need to add this URL in your AppUrls class
        body: body,
      ),
    );

  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Loading posts..."),
        ],
      ),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.colorGrey,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: getTextStyleFromFont(
              AppFont.poppins,
              16,
              AppColors.colorGrey,
              FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CommonButton(
            text: "Retry",
            backgroundColor: AppColors.colorPrimary,
            onTap: _refreshPosts,
            height: 40,
            width: 100,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
      valueListenables: [
        isPostLoading,
        isApiLoading,
        isLoadingMoreSimilar,
        isLoadingMoreInterest,
        hasMoreSimilarData,
        hasMoreInterestData,
        isInterestLoading,
        allSimilarPosts,
        allInterestMatches,
      ],
      builder: (context, values, child) {
        return MultiBlocListener(
          listeners: [
            // Similar Posts Bloc Listener
            BlocListener<GetSimilarPostsBloc, GetSimilarPostsState>(
              listener: (context, state) {
                isApiLoading.value = state is GetSimilarPostsLoading && allSimilarPosts.value.isEmpty;

                if (state is GetSimilarPostsFailure) {
                  isLoadingMoreSimilar.value = false;
                  if (state.errorMessage.generalError?.isNotEmpty == true) {
                    ToastController.showToast(
                      context,
                      state.errorMessage.generalError ?? 'Something went wrong',
                      false,
                    );
                  }
                }

                if (state is GetSimilarPostsResponse) {
                  isLoadingMoreSimilar.value = false;

                  // If it's first load, replace the list
                  if (currentSimilarPage == 0) {
                    allSimilarPosts.value = state.modelSimilarPosts.data ?? [];
                  } else {
                    // If it's load more, append to existing list
                    List<SimilarPostData> updatedList = List.from(allSimilarPosts.value);
                    updatedList.addAll(state.modelSimilarPosts.data ?? []);
                    allSimilarPosts.value = updatedList;
                  }

                  // Check if there's more data to load
                  if ((state.modelSimilarPosts.data?.length ?? 0) < pageSize) {
                    hasMoreSimilarData.value = false;
                  }
                }
              },
            ),
            // Interest Matches Bloc Listener
            BlocListener<GetInterestMatchesBloc, GetInterestMatchesState>(
              listener: (context, state) {
                isInterestLoading.value =
                    state is GetInterestMatchesLoading && allInterestMatches.value.isEmpty;

                if (state is GetInterestMatchesFailure) {
                  isLoadingMoreInterest.value = false;
                  isInterestLoading.value = false;

                  if (state.errorMessage.generalError?.isNotEmpty == true) {
                    ToastController.showToast(
                      context,
                      state.errorMessage.generalError ?? 'Something went wrong with interest matches',
                      false,
                    );
                  }
                }

                if (state is GetInterestMatchesResponse) {
                  isLoadingMoreInterest.value = false;
                  isInterestLoading.value = false;

                  // If it's first load, replace the list
                  if (currentInterestPage == 0) {
                    allInterestMatches.value = state.modelInterestMatches.data ?? [];
                  } else {
                    // If it's load more, append to existing list
                    List<SimilarPostData> updatedList = List.from(allInterestMatches.value);
                    updatedList.addAll(state.modelInterestMatches.data ?? []);
                    allInterestMatches.value = updatedList;
                  }

                  // Check if there's more data to load
                  if ((state.modelInterestMatches.data?.length ?? 0) < pageSize) {
                    hasMoreInterestData.value = false;
                  }
                }
              },
            ),
            // Add User Post Bloc Listener
            BlocListener<AddUserPostBloc, AddUserPostState>(
              listener: (context, state) {
                if (state is AddUserPostLoading) {
                  isPostLoading.value = true;
                }

                if (state is AddUserPostSuccess) {
                  isPostLoading.value = false;

                  // Show green success toast
                  ToastController.showToast(
                    context,
                    "Your search is now public",
                    true, // This parameter makes it green/success toast
                  );
                  isPubliclyPostDone.value = true;

                  // Optionally refresh the posts after successful posting
                  _refreshPosts();
                }

                if (state is AddUserPostFailure) {
                  isPostLoading.value = false;

                  // Show red error toast
                  ToastController.showToast(
                    context,
                    state.errorMessage.generalError ?? 'Failed to post publicly',
                    false, // This parameter makes it red/error toast
                  );
                }
              },
            ),
          ],
          child: Scaffold(
            backgroundColor: AppColors.colorRoundedBgContainer,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: AppColors.colorGrey,
                onPressed: () {
                  Navigator.pop(context);
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
            body: IgnorePointer(
              ignoring: isApiLoading.value,
              child: getBody(),
            ),
          ),
        );
      },
    );
  }

  Widget getBody() {
    return Column(
      children: [
        _buildUserPostCard(),
        Expanded(
          child: Builder(
            builder: (context) {
              // Show loading only for initial load of similar posts (not for load more)
              if (isApiLoading.value && allSimilarPosts.value.isEmpty) {
                return _buildLoadingView();
              }

              // Show error only if no data exists for similar posts
              // You can add error handling here based on your bloc states

              // Always show the tabs with current data (even during load more)
              return SimilarInterestTabs(
                similarPosts: allSimilarPosts.value,
                interestMatches: allInterestMatches.value,
                onLoadMoreSimilar: _loadMoreSimilarPosts,
                onLoadMoreInterest: _loadMoreInterestMatches,
                onRefresh: _refreshPosts,
                isLoadingMoreSimilar: isLoadingMoreSimilar.value,
                isLoadingMoreInterest: isLoadingMoreInterest.value,
                hasMoreSimilarData: hasMoreSimilarData.value,
                hasMoreInterestData: hasMoreInterestData.value,
                isInterestLoading: isInterestLoading.value,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserPostCard() {
    if(isPubliclyPostDone.value) return SizedBox();
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
                  description,
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
            text: isPostLoading.value ? "Posting..." : "Post Publicly",
            backgroundColor: AppColors.colorPrimary,
            height: 48,
            onTap: isPostLoading.value ? null : _postPublicly,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    isPostLoading.dispose();
    isApiLoading.dispose();
    isLoadingMoreSimilar.dispose();
    isLoadingMoreInterest.dispose();
    hasMoreSimilarData.dispose();
    hasMoreInterestData.dispose();
    isInterestLoading.dispose();
    allSimilarPosts.dispose();
    allInterestMatches.dispose();
    super.dispose();
  }
}

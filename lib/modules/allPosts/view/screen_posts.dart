import 'package:cennec/modules/core/utils/app_get_selected_interest.dart';
import 'package:flutter/services.dart';

import '../../chat/models/MessageRoomRequestData.dart';
import '../../connections/model/model_send_request.dart';
import '../../core/utils/app_urls.dart';
import '../../core/utils/common_import.dart';
import 'package:http/http.dart' as http;

import '../../search_posts/view/user_send_request_bottomsheet.dart';
import '../bloc/get_posts_bloc.dart';
import '../model/model_posts.dart';
import '../repository/repository_posts.dart';

class ScreenPosts extends StatefulWidget {
  const ScreenPosts({super.key});

  @override
  State<ScreenPosts> createState() => _ScreenPostsState();
}

class _ScreenPostsState extends State<ScreenPosts> {
  late GetPostsBloc _getPostsBloc;
  final ScrollController _scrollController = ScrollController();
  String _currentOrderBy = "interest_match_count";
  String _currentSort = "desc";

  @override
  void initState() {
    super.initState();
    // Set the status bar to a dark theme manually

    _getPostsBloc = GetPostsBloc(
      repositoryPosts: RepositoryPosts(),
      apiProvider: ApiProvider(),
      client: http.Client(),
    );
    _loadInitialPosts();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMorePosts();
      }
    });
  }

  void _loadInitialPosts() {
    _getPostsBloc.add(GetPosts(
      url: AppUrls.apiGetAllPosts,
      orderBy: _currentOrderBy,
      sort: _currentSort,
      skip: 0,
      take: 10,
    ));
  }

  void _loadMorePosts() {
    _getPostsBloc.add(LoadMorePosts(
      url: AppUrls.apiGetAllPosts,
      orderBy: _currentOrderBy,
      sort: _currentSort,
      take: 10,
    ));
  }

  void _changeSortOrder(String orderBy) {
    setState(() {
      _currentOrderBy = orderBy;
    });
    _loadInitialPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetPostsBloc>(
        create: (context) => _getPostsBloc,
        child: Scaffold(
          backgroundColor: AppColors.colorRoundedBgContainer,
          appBar: AppBar(
            elevation: 0, // No shadow
            backgroundColor: Colors.transparent, // Transparent background
            centerTitle: true, // Ensures the title is centered on all platforms
            title: Text(
              "All Posts",
              style: getTextStyleFromFont(
                AppFont.poppins,
                Dimens.margin26,
                Theme.of(context).colorScheme.onPrimary,
                FontWeight.w600,
              ),
            ),
          ),
          body: BlocBuilder<GetPostsBloc, GetPostsState>(
            builder: (context, state) {
              if (state is GetPostsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetPostsResponse) {
                final posts = state.modelPosts.data ?? [];

                if (posts.isEmpty) {
                  return Center(
                    child: Text(
                      "No posts available",
                      style: getTextStyleFromFont(
                        AppFont.poppins,
                        Dimens.margin16,
                        Theme.of(context).hintColor,
                        FontWeight.w400,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    _loadInitialPosts();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: posts.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == posts.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final post = posts[index];
                      return _buildPostCard(post);
                    },
                  ),
                );
              } else if (state is GetPostsFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage.generalError ?? "Something went wrong",
                        textAlign: TextAlign.center,
                        style: getTextStyleFromFont(
                          AppFont.poppins,
                          Dimens.margin16,
                          Theme.of(context).colorScheme.onBackground,
                          FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadInitialPosts,
                        child: Text(
                          "Retry",
                          style: getTextStyleFromFont(
                            AppFont.poppins,
                            Dimens.margin14,
                            Colors.white,
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ));
  }

  Widget _buildPostCard(PostData post) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Description
            Text(
              post.description ?? "",
              style: getTextStyleFromFont(
                AppFont.poppins,
                16,
                Theme.of(context).colorScheme.onPrimary,
                FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            const Divider(height: 1, color: Colors.grey),

            const SizedBox(height: 12),

            // User info and icon row
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: post.userImage != null && post.userImage!.isNotEmpty
                      ? NetworkImage(post.userImage!)
                      : null,
                  child: (post.userImage == null || post.userImage!.isEmpty)
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),

                const SizedBox(width: 12),

                // Username
                Expanded(
                  child: Text(
                    post.userName ?? "Unknown User",
                    style: getTextStyleFromFont(
                      AppFont.poppins,
                      16,
                      Theme.of(context).colorScheme.onPrimary,
                      FontWeight.w500,
                    ),
                  ),
                ),

                // Friend / Chat Icon with logic
                InkWell(
                  onTap: () {
                    if (post.isFriend == true) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.routesScreenChats,
                        arguments: MessageRoomRequestData(
                          fromUserId: post.userId ?? 0,
                          page: 1,
                          name: post.userName ?? '',
                          imageUrl: post.userImage ?? '',
                        ),
                      );
                    } else {
                      showModalBottomSheet(
                        context: context,
                        constraints: BoxConstraints(
                          maxHeight:  MediaQuery.of(context).size.height * 0.75,
                        ),
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (_) => BottomSheetConnectRequest(
                          // currentUserImage: '${getUser().userData?.defaultProfilePic}',
                          // targetUserImage: '${post.userImage}',
                          // targetUserName: '${post.userName}',
                          // // mutualInterests: InterestHelper.getMutualInterests(
                          // //     loggedInUserInterests, post.),
                          // mutualInterests: ["Box Cricket "],
                          // message: '''Hey ${post.userName}!
//
// ${post.discussionTopic}

// Would you be interested?''',
                          modelRequestDataTransfer: ModelRequestDataTransfer(
                            isFromDashboard: true,
                            getUserId: getUser().userData?.id,
                            toSendUserID: post.userId,
                          ),
                        ),
                      );
//                       Navigator.pushNamed(
//                         context,
//                         AppRoutes.routesScreenUserDetails,
//                         arguments: ModelRequestDataTransfer(
//                           getUserId: post.userId ?? 0,
//                           isFromDashboard: true,
//                         ),
//                       );
                    }
                  },
                  child: _buildFriendIcon(post.isFriend ?? false),
                ),
              ],
            ),
          ],
        ),
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
        color: isFriend ? AppColors.colorHyperLink : Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _getPostsBloc.close();
    super.dispose();
  }
}

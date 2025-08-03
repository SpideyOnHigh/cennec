import 'package:cennec/modules/core/utils/my_print.dart';
import 'package:flutter/services.dart';
import '../../core/common/widgets/common_appbar.dart';
import '../../core/common/widgets/dialog/common_loading_animation.dart';
import '../../core/common/widgets/toast_controller.dart';
import '../../core/utils/app_urls.dart';
import '../../core/utils/common_import.dart';
import 'package:http/http.dart' as http;
import '../bloc/get_my_posts_bloc.dart';
import '../model/model_my_posts.dart';
import '../repository/repository_my_posts.dart';

class ScreenMyPosts extends StatefulWidget {
  const ScreenMyPosts({super.key});

  @override
  State<ScreenMyPosts> createState() => _ScreenMyPostsState();
}

class _ScreenMyPostsState extends State<ScreenMyPosts> {
  late GetMyPostsBloc _getMyPostsBloc;
  final ScrollController _scrollController = ScrollController();
  String _currentOrderBy = "created_at";
  String _currentSort = "desc";

  @override
  void initState() {
    super.initState();
    _getMyPostsBloc = GetMyPostsBloc(
      repositoryMyPosts: RepositoryMyPosts(),
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
    _getMyPostsBloc.add(GetMyPosts(
      url: AppUrls.apiGetAllUserPosts, // You'll need to add this URL constant
      orderBy: _currentOrderBy,
      sort: _currentSort,
      skip: 0,
      take: 5,
    ));
  }

  void _loadMorePosts() {
    _getMyPostsBloc.add(LoadMoreMyPosts(
      url: AppUrls.apiGetAllUserPosts,
      orderBy: _currentOrderBy,
      sort: _currentSort,
      take: 5,
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
    return BlocProvider<GetMyPostsBloc>(
      create: (context) => _getMyPostsBloc,
      child: Scaffold(
        backgroundColor: AppColors.colorRoundedBgContainer,
        appBar: CommonAppBar(title: "My Posts",
        action: [
          PopupMenuButton<String>(
                color: Colors.white,
                onSelected: _changeSortOrder,
                icon: Icon(
                  Icons.sort,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'created_at',
                    child: Text('Sort by Date'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'interest_match_count',
                    child: Text('Sort by Interest Match'),
                  ),
                ],
              ),
        ],
        ),
        // appBar: AppBar(
        //   systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: Colors.transparent,
        //     statusBarIconBrightness: Brightness.dark,
        //     statusBarBrightness: Brightness.light,
        //   ),
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        //   centerTitle: false,
        //   leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: Icon(
        //       Icons.arrow_back_ios,
        //       color: Theme.of(context).colorScheme.onPrimary,
        //     ),
        //   ),
        //   title: Text(
        //     "My Posts",
        //     style: getTextStyleFromFont(
        //       AppFont.poppins,
        //       Dimens.margin26,
        //       Theme.of(context).colorScheme.onPrimary,
        //       FontWeight.w600,
        //     ),
        //   ),
        //   actions: [
        //     PopupMenuButton<String>(
        //       color: Colors.white,
        //       onSelected: _changeSortOrder,
        //       icon: Icon(
        //         Icons.sort,
        //         color: Theme.of(context).colorScheme.onPrimary,
        //       ),
        //       itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        //         const PopupMenuItem<String>(
        //           value: 'created_at',
        //           child: Text('Sort by Date'),
        //         ),
        //         const PopupMenuItem<String>(
        //           value: 'interest_match_count',
        //           child: Text('Sort by Interest Match'),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        body: BlocListener<GetMyPostsBloc, GetMyPostsState>(
          listener: (context, state) {
            if (state is GetMyPostsDeleteSuccess) {
              ToastController.showToast(
                  context,
                  state.message ?? 'Profile updated successfully!',
                  true
              );
            } else if (state is GetMyPostsDeleteFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage.generalError ?? "Failed to delete post",
                    style: getTextStyleFromFont(
                      AppFont.poppins,
                      Dimens.margin14,
                      Colors.white,
                      FontWeight.w400,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<GetMyPostsBloc, GetMyPostsState>(
            builder: (context, state) {
              if (state is GetMyPostsLoading) {
                return const Center(child: CommonLoadingAnimation());
              } else if (state is GetMyPostsResponse ||
                  state is GetMyPostsDeleting ||
                  state is GetMyPostsDeleteSuccess ||
                  state is GetMyPostsDeleteFailure) {

                ModelMyPosts modelMyPosts;
                bool isLoadingMore = false;
                int? deletingPostId;

                if (state is GetMyPostsResponse) {
                  modelMyPosts = state.modelMyPosts;
                  isLoadingMore = state.isLoadingMore;
                } else if (state is GetMyPostsDeleting) {
                  modelMyPosts = state.modelMyPosts;
                  deletingPostId = state.deletingPostId;
                } else if (state is GetMyPostsDeleteSuccess) {
                  modelMyPosts = state.modelMyPosts;
                } else if (state is GetMyPostsDeleteFailure) {
                  modelMyPosts = state.modelMyPosts;
                } else {
                  return const SizedBox.shrink();
                }

                final posts = modelMyPosts.data ?? [];

                if (posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.post_add,
                          size: 64,
                          color: Theme.of(context).hintColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No posts yet",
                          style: getTextStyleFromFont(
                            AppFont.poppins,
                            Dimens.margin18,
                            Theme.of(context).hintColor,
                            FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Start creating posts to connect with others",
                          style: getTextStyleFromFont(
                            AppFont.poppins,
                            Dimens.margin14,
                            Theme.of(context).hintColor,
                            FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    _loadInitialPosts();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                    itemCount: posts.length + (isLoadingMore ? 1 : 0),
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
                      final isDeleting = deletingPostId == post.id;
                      return _buildMyPostCard(post, isDeleting);
                    },
                  ),
                );
              } else if (state is GetMyPostsFailure) {
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
        ),
      ),
    );
  }

  Widget _buildMyPostCard(MyPostData post, [bool isDeleting = false]) {
    MyPrint.printOnConsole(" post.userName: ${post.toJson()} ${ post.id}");
    return Opacity(
      opacity: isDeleting ? 0.5 : 1.0,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post description
                  Text(
                    post.description ?? "",
                    style: getTextStyleFromFont(
                      AppFont.poppins,
                      16,
                      Theme.of(context).colorScheme.onPrimary,
                      FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Interest match count
                  // if (post.interestMatchCount != null)
                  //   Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //     decoration: BoxDecoration(
                  //       color: AppColors.colorHyperLink.withOpacity(0.1),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Text(
                  //       "${post.interestMatchCount} interest matches",
                  //       style: getTextStyleFromFont(
                  //         AppFont.poppins,
                  //         12,
                  //         AppColors.colorHyperLink,
                  //         FontWeight.w500,
                  //       ),
                  //     ),
                  //   ),
                  //
                  // // User interests
                  // if (post.userInterest != null && post.userInterest!.isNotEmpty) ...[
                  //   const SizedBox(height: 12),
                  //   Wrap(
                  //     spacing: 8,
                  //     runSpacing: 4,
                  //     children: post.userInterest!.map((interest) {
                  //       return Container(
                  //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //         decoration: BoxDecoration(
                  //           color: interest.interestMatch == true
                  //               ? Colors.green.withOpacity(0.1)
                  //               : Colors.grey.withOpacity(0.1),
                  //           borderRadius: BorderRadius.circular(8),
                  //           border: Border.all(
                  //             color: interest.interestMatch == true
                  //                 ? Colors.green
                  //                 : Colors.grey,
                  //             width: 1,
                  //           ),
                  //         ),
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             if (interest.interestMatch == true) ...[
                  //               const Icon(Icons.check_circle, size: 12, color: Colors.green),
                  //               const SizedBox(width: 4),
                  //             ],
                  //             Text(
                  //               interest.interestName ?? "",
                  //               style: getTextStyleFromFont(
                  //                 AppFont.poppins,
                  //                 11,
                  //                 interest.interestMatch == true ? Colors.green : Colors.grey.shade600,
                  //                 FontWeight.w400,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ],
                  //
                  // const SizedBox(height: 16),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 12),

                  // Post metadata row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: post.userImage != null && post.userImage!.isNotEmpty
                            ? NetworkImage(post.userImage!)
                            : null,
                        child: (post.userImage == null || post.userImage!.isEmpty)
                            ? const Icon(Icons.person, color: Colors.white, size: 16)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.userName ?? "You",
                              style: getTextStyleFromFont(
                                AppFont.poppins,
                                14,
                                Theme.of(context).colorScheme.onPrimary,
                                FontWeight.w500,
                              ),
                            ),
                            if (post.createdAt != null)
                              Text(
                                _formatDate(post.createdAt!),
                                style: getTextStyleFromFont(
                                  AppFont.poppins,
                                  12,
                                  Theme.of(context).hintColor,
                                  FontWeight.w400,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Options menu
                      if (!isDeleting)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () => _showDeleteConfirmation(post),
                        ),

                    ],
                  ),
                ],
              ),
            ),
            // Deleting overlay
            if (isDeleting)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return "${difference.inDays}d ago";
      } else if (difference.inHours > 0) {
        return "${difference.inHours}h ago";
      } else if (difference.inMinutes > 0) {
        return "${difference.inMinutes}m ago";
      } else {
        return "Just now";
      }
    } catch (e) {
      return dateString;
    }
  }

  void _showDeleteConfirmation(MyPostData post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete Post",
            style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin18,
              Theme.of(context).colorScheme.onPrimary,
              FontWeight.w600,
            ),
          ),
          content: Text(
            "Are you sure you want to delete this post? This action cannot be undone.",
            style: getTextStyleFromFont(
              AppFont.poppins,
              Dimens.margin14,
              Theme.of(context).colorScheme.onPrimary,
              FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin14,
                  Theme.of(context).hintColor,
                  FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement delete post functionality
                _deletePost(post);
              },
              child: Text(
                "Delete",
                style: getTextStyleFromFont(
                  AppFont.poppins,
                  Dimens.margin14,
                  Colors.red,
                  FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deletePost(MyPostData post) {
    _getMyPostsBloc.add(DeleteMyPost(
      url: AppUrls.apiDeletePost, // You'll need to add this URL constant
      postId: post.id ?? 0,
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _getMyPostsBloc.close();
    super.dispose();
  }
}
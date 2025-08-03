part of 'get_my_posts_bloc.dart';

abstract class GetMyPostsState extends Equatable {
  const GetMyPostsState();
  @override
  List<Object?> get props => [];
}

class GetMyPostsInitial extends GetMyPostsState {
  @override
  List<Object> get props => [];
}

class GetMyPostsLoading extends GetMyPostsState {
  @override
  List<Object> get props => [];
}

class GetMyPostsResponse extends GetMyPostsState {
  final ModelMyPosts modelMyPosts;
  final bool isLoadingMore;

  const GetMyPostsResponse({
    required this.modelMyPosts,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [modelMyPosts, isLoadingMore];
}

class GetMyPostsFailure extends GetMyPostsState {
  final ModelError errorMessage;

  const GetMyPostsFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class GetMyPostsDeleting extends GetMyPostsState {
  final ModelMyPosts modelMyPosts;
  final int deletingPostId;

  const GetMyPostsDeleting({
    required this.modelMyPosts,
    required this.deletingPostId,
  });

  @override
  List<Object> get props => [modelMyPosts, deletingPostId];
}

class GetMyPostsDeleteSuccess extends GetMyPostsState {
  final ModelMyPosts modelMyPosts;
  final String message;

  const GetMyPostsDeleteSuccess({
    required this.modelMyPosts,
    required this.message,
  });

  @override
  List<Object> get props => [modelMyPosts, message];
}

class GetMyPostsDeleteFailure extends GetMyPostsState {
  final ModelMyPosts modelMyPosts;
  final ModelError errorMessage;

  const GetMyPostsDeleteFailure({
    required this.modelMyPosts,
    required this.errorMessage,
  });

  @override
  List<Object> get props => [modelMyPosts, errorMessage];
}
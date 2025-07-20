part of 'get_posts_bloc.dart';

abstract class GetPostsState extends Equatable {
  const GetPostsState();
  @override
  List<Object?> get props => [];
}

class GetPostsInitial extends GetPostsState {
  @override
  List<Object> get props => [];
}

class GetPostsLoading extends GetPostsState {
  @override
  List<Object> get props => [];
}

class GetPostsResponse extends GetPostsState {
  final ModelPosts modelPosts;
  final bool isLoadingMore;

  const GetPostsResponse({
    required this.modelPosts,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [modelPosts, isLoadingMore];
}

class GetPostsFailure extends GetPostsState {
  final ModelError errorMessage;

  const GetPostsFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
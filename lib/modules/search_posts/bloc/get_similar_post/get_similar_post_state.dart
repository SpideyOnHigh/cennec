part of 'get_similar_post_bloc.dart';

abstract class GetSimilarPostsState extends Equatable {
  const GetSimilarPostsState();
  @override
  List<Object> get props => [];
}

class GetSimilarPostsInitial extends GetSimilarPostsState {
  @override
  List<Object> get props => [];
}

class GetSimilarPostsLoading extends GetSimilarPostsState {
  @override
  List<Object> get props => [];
}

class GetSimilarPostsResponse extends GetSimilarPostsState {
  final ModelSimilarPosts modelSimilarPosts;

  const GetSimilarPostsResponse({required this.modelSimilarPosts});
  @override
  List<Object> get props => [modelSimilarPosts];
}

class GetSimilarPostsFailure extends GetSimilarPostsState {
  final ModelError errorMessage;

  const GetSimilarPostsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
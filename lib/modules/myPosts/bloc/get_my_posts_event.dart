part of 'get_my_posts_bloc.dart';

abstract class GetMyPostsEvent extends Equatable {
  const GetMyPostsEvent();
  @override
  List<Object?> get props => [];
}

class GetMyPosts extends GetMyPostsEvent {
  final String url;
  final String? orderBy;
  final String? sort;
  final int? skip;
  final int? take;

  const GetMyPosts({
    required this.url,
    this.orderBy,
    this.sort,
    this.skip,
    this.take,
  });

  @override
  List<Object?> get props => [url, orderBy, sort, skip, take];
}

class LoadMoreMyPosts extends GetMyPostsEvent {
  final String url;
  final String? orderBy;
  final String? sort;
  final int? take;

  const LoadMoreMyPosts({
    required this.url,
    this.orderBy,
    this.sort,
    this.take,
  });

  @override
  List<Object?> get props => [url, orderBy, sort, take];
}

class DeleteMyPost extends GetMyPostsEvent {
  final String url;
  final int postId;

  const DeleteMyPost({
    required this.url,
    required this.postId,
  });

  @override
  List<Object?> get props => [url, postId];
}
part of 'get_posts_bloc.dart';

abstract class GetPostsEvent extends Equatable {
  const GetPostsEvent();
  @override
  List<Object?> get props => [];
}

class GetPosts extends GetPostsEvent {
  final String url;
  final String? orderBy;
  final String? sort;
  final int? skip;
  final int? take;

  const GetPosts({
    required this.url,
    this.orderBy,
    this.sort,
    this.skip,
    this.take,
  });

  @override
  List<Object?> get props => [url, orderBy, sort, skip, take];
}

class LoadMorePosts extends GetPostsEvent {
  final String url;
  final String? orderBy;
  final String? sort;
  final int? take;

  const LoadMorePosts({
    required this.url,
    this.orderBy,
    this.sort,
    this.take,
  });

  @override
  List<Object?> get props => [url, orderBy, sort, take];
}
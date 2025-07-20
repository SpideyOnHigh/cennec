part of 'get_similar_post_bloc.dart';

abstract class GetSimilarPostsEvent extends Equatable {
  const GetSimilarPostsEvent();
  @override
  List<Object> get props => [];
}

class GetSimilarPosts extends GetSimilarPostsEvent {
  final String url;
  final Map<String, dynamic> body;

  const GetSimilarPosts({required this.url, required this.body});
  @override
  List<Object> get props => [url, body];
}
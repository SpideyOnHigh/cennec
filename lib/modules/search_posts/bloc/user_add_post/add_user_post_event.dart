part of 'add_user_post_bloc.dart';

abstract class AddUserPostEvent extends Equatable {
  const AddUserPostEvent();
  @override
  List<Object> get props => [];
}

class AddUserPost extends AddUserPostEvent {
  final String url;
  final Map<String, dynamic> body;

  const AddUserPost({required this.url, required this.body});

  @override
  List<Object> get props => [url, body];
}
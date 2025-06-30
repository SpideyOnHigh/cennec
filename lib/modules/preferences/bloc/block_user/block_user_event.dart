part of 'block_user_bloc.dart';

abstract class BlockUserEvent extends Equatable {
  const BlockUserEvent();
  @override
  List<Object> get props => [];
}

class BlockUser extends BlockUserEvent {
  final Map<String,dynamic> body;
  final String url;

  const BlockUser({required this.body, required this.url});
  @override
  List<Object> get props => [url,body];
}

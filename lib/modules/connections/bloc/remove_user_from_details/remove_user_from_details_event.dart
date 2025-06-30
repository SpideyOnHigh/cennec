part of 'remove_user_from_details_bloc.dart';

abstract class RemoveUserFromDetailsEvent extends Equatable {
  const RemoveUserFromDetailsEvent();
  @override
  List<Object> get props => [];
}

class RemoveUserFromDetails extends RemoveUserFromDetailsEvent {
  final String url;

  const RemoveUserFromDetails({required this.url});
  @override
  List<Object> get props => [];
}

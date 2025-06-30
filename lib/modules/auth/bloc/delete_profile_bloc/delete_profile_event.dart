part of 'delete_profile_bloc.dart';

abstract class DeleteProfileEvent extends Equatable {
  const DeleteProfileEvent();
  @override
  List<Object> get props => [];
}

class DeleteProfile extends DeleteProfileEvent {
  final Map<String,dynamic> body;
  final String url;

  const DeleteProfile({required this.body, required this.url});
  @override
  List<Object> get props => [body,url];
}

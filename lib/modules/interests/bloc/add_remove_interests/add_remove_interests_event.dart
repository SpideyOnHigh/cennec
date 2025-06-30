part of 'add_remove_interests_bloc.dart';

abstract class AddRemoveInterestsEvent extends Equatable {
  const AddRemoveInterestsEvent();
  @override
  List<Object> get props => [];
}

class AddRemoveInterests extends AddRemoveInterestsEvent {
  final Map<String,dynamic> body;
  final String url;

  const AddRemoveInterests({required this.body, required this.url});
  @override
  List<Object> get props => [body,url];
}

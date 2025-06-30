part of 'add_remove_interests_bloc.dart';

abstract class AddRemoveInterestsState extends Equatable {
  const AddRemoveInterestsState();
  @override
  List<Object> get props => [];
}

class AddRemoveInterestsInitial extends AddRemoveInterestsState {
  @override
  List<Object> get props => [];
}

class AddRemoveInterestsLoading extends AddRemoveInterestsState {
  @override
  List<Object> get props => [];
}

class AddRemoveInterestsResponse extends AddRemoveInterestsState {
    final ModelAddOrRemoveInterests modelAddOrRemoveInterests;

  const AddRemoveInterestsResponse({required this.modelAddOrRemoveInterests});
  @override
  List<Object> get props => [modelAddOrRemoveInterests];
}

class AddRemoveInterestsFailure extends AddRemoveInterestsState {
  final ModelError errorMessage;

  const AddRemoveInterestsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

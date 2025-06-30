part of 'remove_from_favourite_bloc.dart';

abstract class RemoveFromFavouriteState extends Equatable {
  const RemoveFromFavouriteState();
  @override
  List<Object> get props => [];
}

class RemoveFromFavouriteInitial extends RemoveFromFavouriteState {
  @override
  List<Object> get props => [];
}

class RemoveFromFavouriteLoading extends RemoveFromFavouriteState {
  @override
  List<Object> get props => [];
}

class RemoveFromFavouriteResponse extends RemoveFromFavouriteState {
  final ModelSuccess modelSuccess;

  const RemoveFromFavouriteResponse({required this.modelSuccess});
  @override
  List<Object> get props => [modelSuccess];
}

class RemoveFromFavouriteFailure extends RemoveFromFavouriteState {
  final ModelError errorMessage;

  const RemoveFromFavouriteFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

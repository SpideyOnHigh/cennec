part of 'favourites_bloc.dart';

abstract class FavouritesState extends Equatable {
  const FavouritesState();
  @override
  List<Object> get props => [];
}

class FavouritesInitial extends FavouritesState {
  @override
  List<Object> get props => [];
}

class FavouritesLoading extends FavouritesState {
  @override
  List<Object> get props => [];
}

class FavouritesResponse extends FavouritesState {
  final ModelSuccess modelSuccess;

  const FavouritesResponse({required this.modelSuccess});
  @override
  List<Object> get props => [modelSuccess];
}

class FavouritesFailure extends FavouritesState {
  final ModelError errorMessage;

  const FavouritesFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

part of 'get_my_favourites_bloc.dart';

abstract class GetMyFavouritesState extends Equatable {
  const GetMyFavouritesState();
  @override
  List<Object> get props => [];
}

class GetMyFavouritesInitial extends GetMyFavouritesState {
  @override
  List<Object> get props => [];
}

class GetMyFavouritesLoading extends GetMyFavouritesState {
  @override
  List<Object> get props => [];
}

class GetMyFavouritesResponse extends GetMyFavouritesState {
  final ModelMyFavourites modelMyFavourites;

  const GetMyFavouritesResponse({required this.modelMyFavourites});
  @override
  List<Object> get props => [modelMyFavourites];
}

class GetMyFavouritesFailure extends GetMyFavouritesState {
  final ModelError errorMessage;

  const GetMyFavouritesFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

part of 'favourites_bloc.dart';

abstract class FavouritesEvent extends Equatable {
  const FavouritesEvent();
  @override
  List<Object> get props => [];
}

class AddToFavourites extends FavouritesEvent {
  final Map<String,dynamic> body;
  final String url;

  const AddToFavourites({required this.body, required this.url});
  @override
  List<Object> get props => [body,url];
}

part of 'get_my_favourites_bloc.dart';

abstract class GetMyFavouritesEvent extends Equatable {
  const GetMyFavouritesEvent();
  @override
  List<Object> get props => [];
}

class GetMyFavourites extends GetMyFavouritesEvent {
  final String url;

  const GetMyFavourites({required this.url});
  @override
  List<Object> get props => [url];
}

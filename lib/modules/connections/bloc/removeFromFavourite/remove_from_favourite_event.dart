part of 'remove_from_favourite_bloc.dart';

abstract class RemoveFromFavouriteEvent extends Equatable {
  const RemoveFromFavouriteEvent();
  @override
  List<Object> get props => [];
}

class RemoveFromFavourite extends RemoveFromFavouriteEvent {
  final String url;
  const RemoveFromFavourite({required this.url});
  @override
  List<Object> get props => [];
}

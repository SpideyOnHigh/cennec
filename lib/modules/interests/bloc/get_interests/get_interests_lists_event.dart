part of 'get_interests_lists_bloc.dart';

abstract class GetInterestsListsEvent extends Equatable {
  const GetInterestsListsEvent();
  @override
  List<Object> get props => [];
}

class GetInterestsLists extends GetInterestsListsEvent {
  final String url;

  const GetInterestsLists({required this.url});
  @override
  List<Object> get props => [url];
}

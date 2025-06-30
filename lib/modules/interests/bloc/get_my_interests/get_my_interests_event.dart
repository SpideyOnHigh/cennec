part of 'get_my_interests_bloc.dart';

abstract class GetMyInterestsEvent extends Equatable {
  const GetMyInterestsEvent();
  @override
  List<Object> get props => [];
}

class GetMyInterests extends GetMyInterestsEvent {
  final String url;
  const GetMyInterests({required this.url});
  @override
  List<Object> get props => [url];
}

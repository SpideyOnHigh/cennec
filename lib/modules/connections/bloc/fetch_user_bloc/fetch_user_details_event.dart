part of 'fetch_user_details_bloc.dart';

abstract class FetchUserDetailsEvent extends Equatable {
  const FetchUserDetailsEvent();
  @override
  List<Object> get props => [];
}

class FetchUserDetails extends FetchUserDetailsEvent {
  final String url;

  const FetchUserDetails({required this.url,});

  @override
  List<Object> get props => [url,];
}

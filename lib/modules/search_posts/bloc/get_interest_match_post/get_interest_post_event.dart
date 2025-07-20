// Event file content
part of 'get_interest_post_bloc.dart';

abstract class GetInterestMatchesEvent extends Equatable {
  const GetInterestMatchesEvent();
  @override
  List<Object> get props => [];
}

class GetInterestMatches extends GetInterestMatchesEvent {
  final String url;
  final Map<String, dynamic> body;

  const GetInterestMatches({required this.url, required this.body});
  @override
  List<Object> get props => [url, body];
}
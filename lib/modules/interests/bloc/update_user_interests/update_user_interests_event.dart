part of 'update_user_interests_bloc.dart';

abstract class UpdateUserInterestsEvent extends Equatable {
  const UpdateUserInterestsEvent();
  @override
  List<Object> get props => [];
}

class UpdateUserInterests extends UpdateUserInterestsEvent {
  final String url;
  final Map<String,dynamic> body;

  const UpdateUserInterests({required this.url, required this.body});
  @override
  List<Object> get props => [url,body];
}

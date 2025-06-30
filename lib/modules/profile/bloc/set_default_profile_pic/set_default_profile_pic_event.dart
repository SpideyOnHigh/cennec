part of 'set_default_profile_pic_bloc.dart';

abstract class SetDefaultProfilePicEvent extends Equatable {
  const SetDefaultProfilePicEvent();
  @override
  List<Object> get props => [];
}

class SetDefaultProfilePic extends SetDefaultProfilePicEvent {
  final String url;
  final Map<String, dynamic> body;

  const SetDefaultProfilePic({required this.url, required this.body});

  @override
  List<Object> get props => [url,body];
}

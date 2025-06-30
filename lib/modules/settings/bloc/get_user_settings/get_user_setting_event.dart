part of 'get_user_setting_bloc.dart';

abstract class GetUserSettingEvent extends Equatable {
  const GetUserSettingEvent();
  @override
  List<Object> get props => [];
}
class GetUserSettings extends GetUserSettingEvent {
  final String url;

  const GetUserSettings({required this.url});
  @override
  List<Object> get props => [url];
}

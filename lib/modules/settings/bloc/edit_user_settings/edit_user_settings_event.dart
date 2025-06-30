part of 'edit_user_settings_bloc.dart';

abstract class EditUserSettingsEvent extends Equatable {
  const EditUserSettingsEvent();
  @override
  List<Object> get props => [];
}

class EditUserSettings extends EditUserSettingsEvent {
  final Map<String,dynamic> body;
  final String url;

  const EditUserSettings({required this.body, required this.url});
  @override
  List<Object> get props => [body,url];
}



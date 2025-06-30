part of 'get_user_setting_bloc.dart';

abstract class GetUserSettingState extends Equatable {
  const GetUserSettingState();
  @override
  List<Object> get props => [];
}

class GetUserSettingInitial extends GetUserSettingState {
  @override
  List<Object> get props => [];
}

class GetUserSettingLoading extends GetUserSettingState {
  @override
  List<Object> get props => [];
}

class GetUserSettingResponse extends GetUserSettingState {
  final ModelGetUserSettings modelUserSettings;

  const GetUserSettingResponse({required this.modelUserSettings});
  @override
  List<Object> get props => [modelUserSettings];
}

class GetUserSettingFailure extends GetUserSettingState {
  final ModelError errorMessage;

  const GetUserSettingFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

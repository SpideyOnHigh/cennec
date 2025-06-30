part of 'edit_user_settings_bloc.dart';

abstract class EditUserSettingsState extends Equatable {
  const EditUserSettingsState();
  @override
  List<Object> get props => [];
}

class EditUserSettingsInitial extends EditUserSettingsState {
  @override
  List<Object> get props => [];
}

class EditUserSettingsLoading extends EditUserSettingsState {
  @override
  List<Object> get props => [];
}

class EditUserSettingsResponse extends EditUserSettingsState {
  final ModelEditSettingsResponse modelEditSettingsResponse;
  const EditUserSettingsResponse({required this.modelEditSettingsResponse});
  @override
  List<Object> get props => [modelEditSettingsResponse];
}

class EditUserSettingsFailure extends EditUserSettingsState {
  final ModelError errorMessage;

  const EditUserSettingsFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

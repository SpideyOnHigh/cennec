import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/settings/model/model_edit_user_settings.dart';
import 'package:cennec/modules/settings/repository/settings_repository.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'edit_user_settings_event.dart';
part 'edit_user_settings_state.dart';

class EditUserSettingsBloc extends Bloc<EditUserSettingsEvent, EditUserSettingsState> {
  EditUserSettingsBloc({
    required RepositorySettings repositorySettings,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySettings = repositorySettings,
        mApiProvider = apiProvider,
        mClient = client,
        super(EditUserSettingsInitial()) {
    on<EditUserSettings>(_verifyInvCode);
  }

  final RepositorySettings mRepositorySettings;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _verifyInvCode(
      EditUserSettings event,
      Emitter<EditUserSettingsState> emit,
      ) async {
    /// Emitting an SettingsLoading state.
    emit(EditUserSettingsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelEditSettingsResponse modelEditSettingsResponse =
      await mRepositorySettings.editUserSettings(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelEditSettingsResponse.success == true) {
        emit(EditUserSettingsResponse(
          modelEditSettingsResponse: modelEditSettingsResponse,
        ));
      } else {
        emit(EditUserSettingsFailure(errorMessage: modelEditSettingsResponse.error ?? ModelError()));
      }
    } on SocketException {
      emit(  EditUserSettingsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  EditUserSettingsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  EditUserSettingsFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
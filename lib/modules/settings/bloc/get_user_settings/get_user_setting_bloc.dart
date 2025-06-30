import 'package:cennec/modules/settings/model/model_get_user_settings.dart';
import 'package:cennec/modules/settings/repository/settings_repository.dart';
import 'package:http/http.dart' as http;
import '../../../core/api_service/error_model.dart';
import '../../../core/utils/common_import.dart';

part 'get_user_setting_event.dart';
part 'get_user_setting_state.dart';

class GetUserSettingBloc extends Bloc<GetUserSettingEvent, GetUserSettingState> {
  GetUserSettingBloc({
    required RepositorySettings repositorySettings,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySettings = repositorySettings,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetUserSettingInitial()) {
    on<GetUserSettings>(_verifyInvCode);
  }

  final RepositorySettings mRepositorySettings;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _verifyInvCode(
      GetUserSettings event,
      Emitter<GetUserSettingState> emit,
      ) async {
    /// Emitting an SettingsLoading state.
    emit(GetUserSettingLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelGetUserSettings modelUserSettings =
      await mRepositorySettings.getUserSettings(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelUserSettings.success == true) {
        emit(GetUserSettingResponse(
          modelUserSettings: modelUserSettings,
        ));
      } else {
        emit(GetUserSettingFailure(errorMessage: modelUserSettings.error ?? ModelError()));
      }
    } on SocketException {
      emit(  GetUserSettingFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  GetUserSettingFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  GetUserSettingFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
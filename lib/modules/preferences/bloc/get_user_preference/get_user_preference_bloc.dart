import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/preferences/repository/repository_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

import '../../model/model_get_preference.dart';

part 'get_user_preference_event.dart';
part 'get_user_preference_state.dart';

class GetUserPreferenceBloc extends Bloc<GetUserPreferenceEvent, GetUserPreferenceState> {
  GetUserPreferenceBloc({
    required RepositoryPreferences repositoryPreferences,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryPreferences = repositoryPreferences,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetUserPreferenceInitial()) {
    on<GetUserPreference>(updatePreferences);
  }

  final RepositoryPreferences mRepositoryPreferences;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void updatePreferences(
      GetUserPreference event,
      Emitter<GetUserPreferenceState> emit,
      ) async {
    /// Emitting an PreferencesLoading state.
    emit(GetUserPreferenceLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelPreferences modelPreferences =
      await mRepositoryPreferences.getPreferences(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelPreferences.success == true) {
        emit(GetUserPreferenceResponse(
          modelPreferences: modelPreferences,
        ));
      } else {
        emit(GetUserPreferenceFailure(errorMessage: modelPreferences.error ?? ModelError()));
      }
    } on SocketException {
      emit( GetUserPreferenceFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  GetUserPreferenceFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  GetUserPreferenceFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
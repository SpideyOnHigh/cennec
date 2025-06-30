import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/preferences/model/model_get_preference.dart';
import 'package:cennec/modules/preferences/repository/repository_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'post_user_preference_event.dart';
part 'post_user_preference_state.dart';

class PostUserPreferenceBloc extends Bloc<PostUserPreferenceEvent, PostUserPreferenceState> {
  PostUserPreferenceBloc({
    required RepositoryPreferences repositoryPreferences,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryPreferences = repositoryPreferences,
        mApiProvider = apiProvider,
        mClient = client,
        super(PostUserPreferenceInitial()) {
    on<PostUserPreference>(updatePreferences);
  }

  final RepositoryPreferences mRepositoryPreferences;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void updatePreferences(
      PostUserPreference event,
      Emitter<PostUserPreferenceState> emit,
      ) async {
    /// Emitting an PreferencesLoading state.
    emit(PostUserPreferenceLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelPreferences modelPreferences =
      await mRepositoryPreferences.postPreferences(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelPreferences.success == true) {
        emit(PostUserPreferenceResponse(
          modelPreferences: modelPreferences,
        ));
      } else {
        emit(PostUserPreferenceFailure(errorMessage: modelPreferences.error ?? ModelError()));
      }
    } on SocketException {
      emit( PostUserPreferenceFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  PostUserPreferenceFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  PostUserPreferenceFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
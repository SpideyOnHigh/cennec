import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/profile/model/model_edit_profile_pref.dart';
import 'package:cennec/modules/profile/repository/repository_profile.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'get_user_profile_pref_event.dart';
part 'get_user_profile_pref_state.dart';

class GetUserProfilePrefBloc extends Bloc<GetUserProfilePrefEvent, GetUserProfilePrefState> {
  GetUserProfilePrefBloc({
    required RepositoryProfile repositoryProfile,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryProfile = repositoryProfile,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetUserProfilePrefInitial()) {
    on<GetUserProfilePref>(updateProfile);
  }

  final RepositoryProfile mRepositoryProfile;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void updateProfile(
      GetUserProfilePref event,
      Emitter<GetUserProfilePrefState> emit,
      ) async {
    /// Emitting an ProfileLoading state.
    emit(GetUserProfilePrefLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelUserEditProfilePrefs modelUserEditProfilePrefs =
      await mRepositoryProfile.getProfilePref(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelUserEditProfilePrefs.success == true) {
        emit(GetUserProfilePrefResponse(
          modelUserEditProfilePrefs: modelUserEditProfilePrefs,
        ));
      } else {
        emit(GetUserProfilePrefFailure(errorMessage: modelUserEditProfilePrefs.error ?? ModelError()));
      }
    } on SocketException {
      emit( GetUserProfilePrefFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  GetUserProfilePrefFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  GetUserProfilePrefFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/profile/model/model_updated_profile_data.dart';
import 'package:cennec/modules/profile/repository/repository_profile.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'update_user_profile_event.dart';
part 'update_user_profile_state.dart';

class UpdateUserProfileBloc extends Bloc<UpdateUserProfileEvent, UpdateUserProfileState> {
  UpdateUserProfileBloc({
    required RepositoryProfile repositoryProfile,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryProfile = repositoryProfile,
        mApiProvider = apiProvider,
        mClient = client,
        super(UpdateUserProfileInitial()) {
    on<UpdateUserProfile>(updateProfile);
  }

  final RepositoryProfile mRepositoryProfile;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void updateProfile(
      UpdateUserProfile event,
      Emitter<UpdateUserProfileState> emit,
      ) async {
    /// Emitting an ProfileLoading state.
    emit(UpdateUserProfileLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelUpdatedProfileData modelUpdatedProfileData =
      await mRepositoryProfile.updateProfileData(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelUpdatedProfileData.success == true) {
        emit(UpdateUserProfileResponse(
          modelUpdatedProfileData: modelUpdatedProfileData,
        ));
      } else {
        emit(UpdateUserProfileFailure(errorMessage: modelUpdatedProfileData.error ?? ModelError()));
      }
    } on SocketException {
      emit( UpdateUserProfileFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  UpdateUserProfileFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  UpdateUserProfileFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
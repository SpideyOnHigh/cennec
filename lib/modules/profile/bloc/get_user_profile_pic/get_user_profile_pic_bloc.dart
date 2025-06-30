import 'package:cennec/modules/connections/model/model_get_images.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:cennec/modules/profile/repository/repository_profile.dart';
import 'package:http/http.dart' as http;
import '../../../connections/model/model_recommendations.dart';
import '../../../core/utils/common_import.dart';

part 'get_user_profile_pic_event.dart';
part 'get_user_profile_pic_state.dart';

class GetUserProfilePicBloc extends Bloc<GetUserProfilePicEvent, GetUserProfilePicState> {
  GetUserProfilePicBloc({
    required RepositoryProfile repositoryProfile,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryProfile = repositoryProfile,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetUserProfilePicInitial()) {
    on<GetUserProfilePic>(updateProfile);
  }

  final RepositoryProfile mRepositoryProfile;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void updateProfile(
      GetUserProfilePic event,
      Emitter<GetUserProfilePicState> emit,
      ) async {
    /// Emitting an ProfileLoading state.
    emit(GetUserProfilePicLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelGetImages modelUserEditProfilePrefs =
      await mRepositoryProfile.getUserProfilePicture(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelUserEditProfilePrefs.success == true) {
        var user = getUser();
        List<ProfileImages> images = [];
        for(var i in modelUserEditProfilePrefs.data!){
          images.add(ProfileImages(imageId: i.id!,imageUrl: i.imagePath!));
        }
        user.userData?.profileImages = images;
        PreferenceHelper.setString(PreferenceHelper.userData, json.encode(user));
        emit(GetUserProfilePicResponse(
          modelGetImages: modelUserEditProfilePrefs
          // modelUserEditProfilePrefs: modelUserEditProfilePrefs,
        ));
      } else {
        emit(GetUserProfilePicFailure(errorMessage: modelUserEditProfilePrefs.error ?? ModelError()));
      }
    } on SocketException {
      emit( GetUserProfilePicFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  GetUserProfilePicFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  GetUserProfilePicFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}

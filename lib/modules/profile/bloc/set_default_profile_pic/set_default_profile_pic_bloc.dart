import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/profile/repository/repository_profile.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'set_default_profile_pic_event.dart';
part 'set_default_profile_pic_state.dart';

class SetDefaultProfilePicBloc extends Bloc<SetDefaultProfilePicEvent, SetDefaultProfilePicState> {
  SetDefaultProfilePicBloc({
    required RepositoryProfile repositoryProfile,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryProfile = repositoryProfile,
        mApiProvider = apiProvider,
        mClient = client,
        super(SetDefaultProfilePicInitial()) {
    on<SetDefaultProfilePic>(updateProfile);
  }

  final RepositoryProfile mRepositoryProfile;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void updateProfile(
      SetDefaultProfilePic event,
      Emitter<SetDefaultProfilePicState> emit,
      ) async {
    /// Emitting an ProfileLoading state.
    emit(SetDefaultProfilePicLoading());
    try {
      /// This is a way to handle the response from the API call.
       ModelSuccess modelSuccess =
      await mRepositoryProfile.setDefaultProfilePic(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelSuccess.success == true) {
        emit(SetDefaultProfilePicResponse(
          modelSuccess: modelSuccess,
        ));
      } else {
        emit(SetDefaultProfilePicFailure(errorMessage: modelSuccess.error ?? ModelError()));
      }
    } on SocketException {
      emit( SetDefaultProfilePicFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  SetDefaultProfilePicFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  SetDefaultProfilePicFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
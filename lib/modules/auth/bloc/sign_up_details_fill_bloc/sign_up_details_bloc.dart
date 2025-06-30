import 'package:cennec/modules/auth/model/model_registeration.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:cennec/modules/auth/repository/repository_auth.dart';
import 'package:http/http.dart' as http;
import '../../../core/api_service/error_model.dart';
import '../../../core/utils/common_import.dart';

part 'sign_up_details_event.dart';
part 'sign_up_details_state.dart';

class SignUpDetailsBloc extends Bloc<SignUpDetailsEvent, SignUpDetailsState> {
  SignUpDetailsBloc({
    required RepositoryAuth repositoryAuth,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAuth = repositoryAuth,
        mApiProvider = apiProvider,
        mClient = client,
        super(SignUpDetailsInitial()) {
    on<UploadUserSignUpDetails>(_verifyInvCode);
  }

  final RepositoryAuth mRepositoryAuth;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _verifyInvCode(
      UploadUserSignUpDetails event,
      Emitter<SignUpDetailsState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(SignUpDetailsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelRegistration modelRegistration =
      await mRepositoryAuth.registerUser(
        event.url,
        event.body,
        await mApiProvider.getHeaderValue(),
        mApiProvider,
        mClient,
      );
      if (modelRegistration.success == true) {
        PreferenceHelper.setString(PreferenceHelper.userToken,modelRegistration.data?.token ?? '');
        PreferenceHelper.setString(PreferenceHelper.userData, json.encode(modelRegistration.data));
        emit(SignUpDetailsResponse(
          modelRegistration: modelRegistration,
        ));
      } else {
        emit(SignUpDetailsFailure(errorMessage: modelRegistration.error ?? ModelError()));
      }
    } on SocketException {
      emit(  SignUpDetailsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  SignUpDetailsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  SignUpDetailsFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
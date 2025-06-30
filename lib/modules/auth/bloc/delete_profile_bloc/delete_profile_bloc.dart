import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/auth/repository/repository_auth.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'delete_profile_event.dart';
part 'delete_profile_state.dart';

class DeleteProfileBloc extends Bloc<DeleteProfileEvent, DeleteProfileState> {
  DeleteProfileBloc({
    required RepositoryAuth repositoryAuth,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAuth = repositoryAuth,
        mApiProvider = apiProvider,
        mClient = client,
        super(DeleteProfileInitial()) {
    on<DeleteProfile>(_verifyInvCode);
  }

  final RepositoryAuth mRepositoryAuth;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _verifyInvCode(
      DeleteProfile event,
      Emitter<DeleteProfileState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(DeleteProfileLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelSuccess modelSuccess =
      await mRepositoryAuth.deleteAccount(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelSuccess.success == true) {
        emit(DeleteProfileResponse(
          modelSuccess: modelSuccess,
        ));
      } else {
        emit(DeleteProfileFailure(errorMessage: modelSuccess.error ?? ModelError()));
      }
    } on SocketException {
      emit(  DeleteProfileFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  DeleteProfileFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  DeleteProfileFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
import 'package:cennec/modules/auth/model/model_sign_up_inv.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/auth/repository/repository_auth.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'sign_up_invitation_event.dart';
part 'sign_up_invitation_state.dart';

class SignUpInvitationBloc extends Bloc<SignUpInvitationEvent, SignUpInvitationState> {
  SignUpInvitationBloc({
    required RepositoryAuth repositoryAuth,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAuth = repositoryAuth,
        mApiProvider = apiProvider,
        mClient = client,
        super(SignUpInvitationInitial()) {
    on<VerifyInvitationCode>(_verifyInvCode);
  }

  final RepositoryAuth mRepositoryAuth;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _verifyInvCode(
    VerifyInvitationCode event,
    Emitter<SignUpInvitationState> emit,
  ) async {
    /// Emitting an AuthLoading state.
    emit(SignUpInvitationLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelSignUpInvCode modelSignUpInvCode = await mRepositoryAuth.callVerifySignUpInvCode(
        event.url,
        event.body,
        await mApiProvider.getHeaderValue(),
        mApiProvider,
        mClient,
      );
      if (modelSignUpInvCode.success == true) {
        emit(SignUpInvitationResponse(
          modelSignUpInvCode: modelSignUpInvCode,
        ));
      } else {
        printWrapped("modelerror = ${modelSignUpInvCode.error?.invitationCode}");
        emit(SignUpInvitationFailure(errorMessage: modelSignUpInvCode.error ?? ModelError()));
      }
    } on SocketException {
      emit(SignUpInvitationFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error = $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(SignUpInvitationFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(SignUpInvitationFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}

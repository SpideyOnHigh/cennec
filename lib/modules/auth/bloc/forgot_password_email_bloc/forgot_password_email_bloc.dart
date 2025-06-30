import 'package:cennec/modules/auth/model/model_verify_sign_up_otp.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/auth/repository/repository_auth.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';
part 'forgot_password_email_event.dart';
part 'forgot_password_email_state.dart';

class ForgotPasswordEmailBloc extends Bloc<ForgotPasswordEmailEvent, ForgotPasswordEmailState> {
  ForgotPasswordEmailBloc({
    required RepositoryAuth repositoryAuth,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAuth = repositoryAuth,
        mApiProvider = apiProvider,
        mClient = client,
        super(ForgotPasswordEmailInitial()) {
    on<VerifyEmailForForgotPassword>(_verifyInvCode);
  }

  final RepositoryAuth mRepositoryAuth;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _verifyInvCode(
      VerifyEmailForForgotPassword event,
      Emitter<ForgotPasswordEmailState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(ForgotPasswordEmailLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelOtpResetLink modelOtpResetLink =
      await mRepositoryAuth.fetchResetLink(
        event.url,
        event.body,
        await mApiProvider.getHeaderValue(),
        mApiProvider,
        mClient,
      );
      if (modelOtpResetLink.success == true) {
        emit(ForgotPasswordEmailResponse(
          modelOtpResetLink: modelOtpResetLink,
        ));
      } else {
        emit(ForgotPasswordEmailFailure(errorMessage: modelOtpResetLink.error ?? ModelError()));
      }
    } on SocketException {
      emit(  ForgotPasswordEmailFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  ForgotPasswordEmailFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  ForgotPasswordEmailFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
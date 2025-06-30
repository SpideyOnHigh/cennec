import 'package:cennec/modules/auth/model/model_verify_sign_up_otp.dart';
import 'package:cennec/modules/auth/repository/repository_auth.dart';
import 'package:http/http.dart' as http;
import '../../../core/api_service/error_model.dart';
import '../../../core/utils/common_import.dart';

part 'verify_sign_up_otp_event.dart';
part 'verify_sign_up_otp_state.dart';

class VerifySignUpOtpBloc extends Bloc<VerifySignUpOtpEvent, VerifySignUpOtpState> {
  VerifySignUpOtpBloc({
    required RepositoryAuth repositoryAuth,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAuth = repositoryAuth,
        mApiProvider = apiProvider,
        mClient = client,
        super(VerifySignUpOtpInitial()) {
    on<VerifySignUpOtp>(_verifyOtp);
  }

  final RepositoryAuth mRepositoryAuth;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _verifyOtp(
      VerifySignUpOtp event,
      Emitter<VerifySignUpOtpState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(VerifySignUpOtpLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelOtpResetLink modelSignUpInvCode =
      await mRepositoryAuth.fetchResetLink(
        event.url,
        event.body,
        await mApiProvider.getHeaderValue(),
        mApiProvider,
        mClient,
      );
      if (modelSignUpInvCode.success == true) {
        emit(VerifySignUpOtpResponse(
          modelVerifySignUpOtp: modelSignUpInvCode,
        ));
      } else {
        emit(VerifySignUpOtpFailure(errorMessage: modelSignUpInvCode.error ?? ModelError()));
      }
    } on SocketException {
      emit(  VerifySignUpOtpFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  VerifySignUpOtpFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  VerifySignUpOtpFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
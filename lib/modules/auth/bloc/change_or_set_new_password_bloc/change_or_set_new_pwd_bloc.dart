import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/auth/repository/repository_auth.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'change_or_set_new_pwd_event.dart';
part 'change_or_set_new_pwd_state.dart';

class ChangeOrSetNewPwdBloc extends Bloc<ChangeOrSetNewPwdEvent, ChangeOrSetNewPwdState> {
  ChangeOrSetNewPwdBloc({
    required RepositoryAuth repositoryAuth,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAuth = repositoryAuth,
        mApiProvider = apiProvider,
        mClient = client,
        super(ChangeOrSetNewPwdInitial()) {
    on<ChangeOrSetNewPwd>(_verifyInvCode);
    on<ResetPwd>(_resetPwd);
  }

  final RepositoryAuth mRepositoryAuth;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _verifyInvCode(
      ChangeOrSetNewPwd event,
      Emitter<ChangeOrSetNewPwdState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(ChangeOrSetNewPwdLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelSuccess modelSuccess =
      await mRepositoryAuth.changePassword(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelSuccess.success == true) {
        emit(ChangeOrSetNewPwdResponse(
          modelSuccess: modelSuccess,
        ));
      } else {
        emit(ChangeOrSetNewPwdFailure(errorMessage: modelSuccess.error ?? ModelError()));
      }
    } on SocketException {
      emit(  ChangeOrSetNewPwdFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  ChangeOrSetNewPwdFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  ChangeOrSetNewPwdFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }

  void _resetPwd(
      ResetPwd event,
      Emitter<ChangeOrSetNewPwdState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(ChangeOrSetNewPwdLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelSuccess modelSuccess =
      await mRepositoryAuth.changePassword(
        event.url,
        event.body,
        await mApiProvider.getHeaderValue(),
        mApiProvider,
        mClient,
      );
      if (modelSuccess.success == true) {
        emit(ChangeOrSetNewPwdResponse(
          modelSuccess: modelSuccess,
        ));
      } else {
        emit(ChangeOrSetNewPwdFailure(errorMessage:modelSuccess.error ?? ModelError()));
      }
    } on SocketException {
      emit(  ChangeOrSetNewPwdFailure(errorMessage:ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  ChangeOrSetNewPwdFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  ChangeOrSetNewPwdFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
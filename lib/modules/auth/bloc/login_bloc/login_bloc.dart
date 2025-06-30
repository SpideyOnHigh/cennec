import 'package:cennec/modules/auth/model/model_login.dart';
import 'package:cennec/modules/auth/repository/repository_auth.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/common_import.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required RepositoryAuth repositoryAuth,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAuth = repositoryAuth,
        mApiProvider = apiProvider,
        mClient = client,
        super(LoginInitial()) {
    on<OnLogin>(_onLogin);
  }

  final RepositoryAuth mRepositoryAuth;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onAuthNewUser is a function that takes an AuthUser event, an Emitter<AuthState> emit, and returns
  /// a void that emits an AuthLoading state, and then either an AuthResponse state or an
  /// AuthFailure state
  ///
  /// Args:
  ///   event (AuthUser): The event that was dispatched.
  ///   emit (Emitter<AuthState>): This is the function that you use to emit events.
  void _onLogin(
    OnLogin event,
    Emitter<LoginState> emit,
  ) async {
    /// Emitting an AuthLoading state.
    emit(LoginLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelLogin modelLogin = await mRepositoryAuth.callPostMethod(
        event.url,
        event.body,
        await mApiProvider.getHeaderValue(),
        mApiProvider,
        mClient,
      );
      if (modelLogin.success == true) {
        PreferenceHelper.setString(PreferenceHelper.userToken, modelLogin.data?.token ?? '');
        PreferenceHelper.setString(PreferenceHelper.userData, json.encode(modelLogin.data));
        emit(LoginResponse(
          modelLogin: modelLogin,
        ));
      } else {
        printWrapped("in bloc");
        emit(LoginFailure(errorMessage: modelLogin.error ?? ModelError()));
      }
    } on SocketException {
      emit(LoginFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("in excep = $e");
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(LoginFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(LoginFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}

import 'package:cennec/modules/auth/model/model_logout.dart';
import 'package:cennec/modules/auth/repository/repository_auth.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc({
    required RepositoryAuth repositoryLogOut,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryLogOut = repositoryLogOut,
        mApiProvider = apiProvider,
        mClient = client,
        super(LogoutInitial()) {
    on<UserLogout>(_onLogOut);
  }

  final RepositoryAuth mRepositoryLogOut;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onLogOut] of a new [LogOutUser] which triggers
  void _onLogOut(
      UserLogout event,
      Emitter<LogoutState> emit,
      ) async {
    emit(LogoutLoading());
    try {
      ModelLogoutSuccess modelLogOut = await mRepositoryLogOut.callLogout(
        event.url,
        {},
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelLogOut.success == true) {
        emit(LogoutResponse(
          modelLogoutSuccess: modelLogOut,
        ));
      } else {
        emit(LogoutFailure(errorMessage: modelLogOut.error ?? ModelError()));
      }
    } on SocketException {
      emit( LogoutFailure(
        errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit( LogoutFailure(
          errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit( LogoutFailure(
            errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
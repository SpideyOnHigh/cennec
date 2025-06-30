import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:cennec/modules/connections/repository/repository_connections.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'remove_user_event.dart';
part 'remove_user_state.dart';

class RemoveUserFromInterestsBloc extends Bloc<RemoveUserFromInterestsEvent, RemoveUserFromInterestsState> {
  RemoveUserFromInterestsBloc({
    required RepositoryConnections repositoryConnections,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryConnections = repositoryConnections,
        mApiProvider = apiProvider,
        mClient = client,
        super(RemoveUserFromInterestsInitial()) {
    on<RemoveUserFromInterests>(_getConnections);
  }

  final RepositoryConnections mRepositoryConnections;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getConnections(
      RemoveUserFromInterests event,
      Emitter<RemoveUserFromInterestsState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(RemoveUserFromInterestsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelSuccess modelSuccess =
      await mRepositoryConnections.removeUser(
        event.url,
        {},
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelSuccess.success == true) {
        emit(RemoveUserFromInterestsResponse(
          modelSuccess: modelSuccess,
        ));
      } else {
        printWrapped("errrrr");
        emit(RemoveUserFromInterestsFailure(errorMessage: modelSuccess.error ?? ModelError()));
      }
    } on SocketException {
      emit(  RemoveUserFromInterestsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  RemoveUserFromInterestsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  RemoveUserFromInterestsFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
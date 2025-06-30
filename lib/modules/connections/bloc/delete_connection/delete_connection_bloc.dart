import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:cennec/modules/connections/repository/repository_connections.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';


part 'delete_connection_event.dart';
part 'delete_connection_state.dart';

class DeleteConnectionBloc extends Bloc<DeleteConnectionEvent, DeleteConnectionState> {
  DeleteConnectionBloc({
    required RepositoryConnections repositoryConnections,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryConnections = repositoryConnections,
        mApiProvider = apiProvider,
        mClient = client,
        super(DeleteConnectionInitial()) {
    on<DeleteConnection>(_getConnections);
  }

  final RepositoryConnections mRepositoryConnections;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getConnections(
      DeleteConnection event,
      Emitter<DeleteConnectionState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(DeleteConnectionLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelSuccess modelSuccess =
      await mRepositoryConnections.deleteConnection(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelSuccess.success == true) {
        emit(DeleteConnectionResponse(
          modelSuccess: modelSuccess,
        ));
      } else {
        emit(DeleteConnectionFailure(errorMessage: modelSuccess.error ?? ModelError()));
      }
    } on SocketException {
      emit(  DeleteConnectionFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error = $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  DeleteConnectionFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  DeleteConnectionFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
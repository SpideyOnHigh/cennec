import 'package:cennec/modules/connections/model/model_my_connections.dart';
import 'package:cennec/modules/connections/repository/repository_connections.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'get_my_connections_event.dart';
part 'get_my_connections_state.dart';

class GetMyConnectionsBloc extends Bloc<GetMyConnectionsEvent, GetMyConnectionsState> {
  GetMyConnectionsBloc({
    required RepositoryConnections repositoryConnections,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryConnections = repositoryConnections,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetMyConnectionsInitial()) {
    on<GetMyConnections>(_getConnections);
  }

  final RepositoryConnections mRepositoryConnections;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getConnections(
      GetMyConnections event,
      Emitter<GetMyConnectionsState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(GetMyConnectionsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelMyConnections modelMyConnections =
      await mRepositoryConnections.getConnections(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelMyConnections.success == true) {
        emit(GetMyConnectionsResponse(
          modelMyConnections: modelMyConnections,
        ));
      } else {
        printWrapped("errrrr");
        emit(GetMyConnectionsFailure(errorMessage: modelMyConnections.error ?? ModelError()));
      }
    } on SocketException {
      emit(  GetMyConnectionsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  GetMyConnectionsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  GetMyConnectionsFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
import 'package:cennec/modules/connections/repository/repository_connections.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/dashboard/model/model_requests.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/common_import.dart';

part 'get_requests_event.dart';
part 'get_requests_state.dart';

class GetRequestsBloc extends Bloc<GetRequestsEvent, GetRequestsState> {
  GetRequestsBloc({
    required RepositoryConnections repositoryConnections,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryConnections = repositoryConnections,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetRequestsInitial()) {
    on<GetRequests>(getRequests);
  }

  final RepositoryConnections mRepositoryConnections;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void getRequests(
      GetRequests event,
      Emitter<GetRequestsState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(GetRequestsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelRequests modelRequests =
      await mRepositoryConnections.getRequests(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelRequests.success == true) {
        emit(GetRequestsResponse(
          modelRequests: modelRequests,
        ));
      } else {
        printWrapped("errrrr");
        emit(GetRequestsFailure(errorMessage: modelRequests.error ?? ModelError()));
      }
    } on SocketException {
      emit(  GetRequestsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  GetRequestsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  GetRequestsFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
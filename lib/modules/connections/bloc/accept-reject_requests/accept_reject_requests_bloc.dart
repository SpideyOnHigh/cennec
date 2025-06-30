import 'package:cennec/modules/connections/model/model_request_action.dart';
import 'package:cennec/modules/connections/repository/repository_connections.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/common_import.dart';

part 'accept_reject_requests_event.dart';
part 'accept_reject_requests_state.dart';

class AcceptRejectRequestsBloc extends Bloc<AcceptRejectRequestsEvent, AcceptRejectRequestsState> {
  AcceptRejectRequestsBloc({
    required RepositoryConnections repositoryConnections,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryConnections = repositoryConnections,
        mApiProvider = apiProvider,
        mClient = client,
        super(AcceptRejectRequestsInitial()) {
    on<AcceptRejectRequests>(acceptRejectRequests);
  }

  final RepositoryConnections mRepositoryConnections;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void acceptRejectRequests(
      AcceptRejectRequests event,
      Emitter<AcceptRejectRequestsState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(AcceptRejectRequestsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelRequestAction modelRequestAction =
      await mRepositoryConnections.postRequest(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelRequestAction.success == true) {
        emit(AcceptRejectRequestsResponse(
          modelRequestAction: modelRequestAction,
        ));
      } else {
        printWrapped("errrrr");
        emit(AcceptRejectRequestsFailure(errorMessage: modelRequestAction.error ?? ModelError()));
      }
    } on SocketException {
      emit(  AcceptRejectRequestsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  AcceptRejectRequestsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  AcceptRejectRequestsFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
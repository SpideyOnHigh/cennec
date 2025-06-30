import 'package:cennec/modules/connections/model/model_send_request.dart';
import 'package:cennec/modules/connections/repository/repository_connections.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';


part 'send_request_event.dart';
part 'send_request_state.dart';

class SendRequestBloc extends Bloc<SendRequestEvent, SendRequestState> {
  SendRequestBloc({
    required RepositoryConnections repositoryConnections,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryConnections = repositoryConnections,
        mApiProvider = apiProvider,
        mClient = client,
        super(SendRequestInitial()) {
    on<SendRequest>(_getConnections);
  }

  final RepositoryConnections mRepositoryConnections;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getConnections(
      SendRequest event,
      Emitter<SendRequestState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(SendRequestLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelSendRequestResponse modelSendRequestResponse =
      await mRepositoryConnections.sendRequest(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelSendRequestResponse.success == true) {
        emit(SendRequestResponse(
          modelSendRequestResponse: modelSendRequestResponse,
        ));
      } else {
        emit(SendRequestFailure(errorMessage: modelSendRequestResponse.error ?? ModelError()));
      }
    } on SocketException {
      emit(  SendRequestFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  SendRequestFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  SendRequestFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}

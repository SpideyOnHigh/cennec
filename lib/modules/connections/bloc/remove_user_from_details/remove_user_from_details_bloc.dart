import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:cennec/modules/connections/repository/repository_connections.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'remove_user_from_details_event.dart';
part 'remove_user_from_details_state.dart';

class RemoveUserFromDetailsBloc extends Bloc<RemoveUserFromDetailsEvent, RemoveUserFromDetailsState> {
  RemoveUserFromDetailsBloc({
    required RepositoryConnections repositoryConnections,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryConnections = repositoryConnections,
        mApiProvider = apiProvider,
        mClient = client,
        super(RemoveUserFromDetailsInitial()) {
    on<RemoveUserFromDetails>(_getConnections);
  }

  final RepositoryConnections mRepositoryConnections;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getConnections(
      RemoveUserFromDetails event,
      Emitter<RemoveUserFromDetailsState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(RemoveUserFromDetailsLoading());
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
        emit(RemoveUserFromDetailsResponse(
          modelSuccess: modelSuccess,
        ));
      } else {
        printWrapped("errrrr");
        emit(RemoveUserFromDetailsFailure(errorMessage: modelSuccess.error ?? ModelError()));
      }
    } on SocketException {
      emit(  RemoveUserFromDetailsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  RemoveUserFromDetailsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  RemoveUserFromDetailsFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
import 'package:cennec/modules/connections/model/model_fetch_user_detail.dart';
import 'package:cennec/modules/connections/repository/repository_connections.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';
part 'fetch_user_details_event.dart';
part 'fetch_user_details_state.dart';

class FetchUserDetailsBloc extends Bloc<FetchUserDetailsEvent, FetchUserDetailsState> {
  FetchUserDetailsBloc({
    required RepositoryConnections repositoryConnections,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryConnections = repositoryConnections,
        mApiProvider = apiProvider,
        mClient = client,
        super(FetchUserDetailsInitial()) {
    on<FetchUserDetails>(_getConnections);
  }

  final RepositoryConnections mRepositoryConnections;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getConnections(
      FetchUserDetails event,
      Emitter<FetchUserDetailsState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(FetchUserDetailsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelFetchUserDetail modelFetchUserDetail =
      await mRepositoryConnections.getUserDetails(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelFetchUserDetail.success == true) {
        emit(FetchUserDetailsResponse(
          modelFetchUserDetail: modelFetchUserDetail,
        ));
      } else {
        emit(FetchUserDetailsFailure(errorMessage: modelFetchUserDetail.error ?? ModelError()));
      }
    } on SocketException {
      emit(  FetchUserDetailsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error = $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  FetchUserDetailsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  FetchUserDetailsFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
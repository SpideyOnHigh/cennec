import 'package:cennec/modules/connections/repository/repository_connections.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';
import '../../model/model_recommendations.dart';

part 'get_recommendations_event.dart';
part 'get_recommendations_state.dart';

class GetRecommendationsBloc extends Bloc<GetRecommendationsEvent, GetRecommendationsState> {
  GetRecommendationsBloc({
    required RepositoryConnections repositoryConnections,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryConnections = repositoryConnections,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetRecommendationsInitial()) {
    on<GetRecommendations>(_getConnections);
  }

  final RepositoryConnections mRepositoryConnections;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getConnections(
      GetRecommendations event,
      Emitter<GetRecommendationsState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(GetRecommendationsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelRecommendations modelRecommendations =
      await mRepositoryConnections.getRecommendation(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelRecommendations.success == true) {
        emit(GetRecommendationsResponse(
          modelRecommendations: modelRecommendations,
        ));
      } else {
        emit(GetRecommendationsFailure(errorMessage: modelRecommendations.error ?? ModelError()));
      }
    } on SocketException {
      emit(  GetRecommendationsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error = $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  GetRecommendationsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  GetRecommendationsFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/interests/model/model_recommendations_of_interests.dart';
import 'package:cennec/modules/interests/repository/interests_repository.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'recommendations_of_interest_event.dart';
part 'recommendations_of_interest_state.dart';

class RecommendationsOfInterestBloc extends Bloc<RecommendationsOfInterestEvent, RecommendationsOfInterestState> {
  RecommendationsOfInterestBloc({
    required RepositoryInterests repositoryInterests,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryInterests = repositoryInterests,
        mApiProvider = apiProvider,
        mClient = client,
        super(RecommendationsOfInterestInitial()) {
    on<RecommendationsOfInterest>(_getUsers);
  }

  final RepositoryInterests mRepositoryInterests;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getUsers(
      RecommendationsOfInterest event,
      Emitter<RecommendationsOfInterestState> emit,
      ) async {
    /// Emitting an InterestsLoading state.
    emit(RecommendationsOfInterestLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelRecommendationsOfInterest modelRecommendations =
      await mRepositoryInterests.getRecommendations(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelRecommendations.success == true) {
        emit(RecommendationsOfInterestResponse(
          modelRecommendations: modelRecommendations,
        ));
      } else {
        emit(RecommendationsOfInterestFailure(errorMessage: modelRecommendations.error ?? ModelError()));
      }
    } on SocketException {
      emit( RecommendationsOfInterestFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  RecommendationsOfInterestFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  RecommendationsOfInterestFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:cennec/modules/search_posts/model/similar_post_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';
import '../../repository/repository_similar_post.dart';

part 'get_interest_post_event.dart';
part 'get_interest_post_state.dart';
class GetInterestMatchesBloc extends Bloc<GetInterestMatchesEvent, GetInterestMatchesState> {
  GetInterestMatchesBloc({
    required RepositorySimilarPosts repositorySimilarPosts,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySimilarPosts = repositorySimilarPosts,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetInterestMatchesInitial()) {
    on<GetInterestMatches>(getInterestMatches);
  }

  final RepositorySimilarPosts mRepositorySimilarPosts;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void getInterestMatches(
      GetInterestMatches event,
      Emitter<GetInterestMatchesState> emit,
      ) async {
    /// Emitting a GetInterestMatchesLoading state.
    emit(GetInterestMatchesLoading());
    try {
      /// This is a way to handle the response from the API call.
      /// You can use the same model or create a new one for interest matches
      ModelSimilarPosts modelInterestMatches =
      await mRepositorySimilarPosts.getSimilarPosts(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelInterestMatches.code == 200) {
        emit(GetInterestMatchesResponse(
          modelInterestMatches: modelInterestMatches,
        ));
      } else {
        emit(GetInterestMatchesFailure(errorMessage: modelInterestMatches.error ?? ModelError()));
      }
    } on SocketException {
      emit(GetInterestMatchesFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(GetInterestMatchesFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(GetInterestMatchesFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
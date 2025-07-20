import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:cennec/modules/search_posts/model/similar_post_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';
import '../../repository/repository_similar_post.dart';

part 'get_similar_post_event.dart';
part 'get_similar_post_state.dart';

class GetSimilarPostsBloc extends Bloc<GetSimilarPostsEvent, GetSimilarPostsState> {
  GetSimilarPostsBloc({
    required RepositorySimilarPosts repositorySimilarPosts,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySimilarPosts = repositorySimilarPosts,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetSimilarPostsInitial()) {
    on<GetSimilarPosts>(getSimilarPosts);
  }

  final RepositorySimilarPosts mRepositorySimilarPosts;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void getSimilarPosts(
      GetSimilarPosts event,
      Emitter<GetSimilarPostsState> emit,
      ) async {
    /// Emitting a GetSimilarPostsLoading state.
    emit(GetSimilarPostsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelSimilarPosts modelSimilarPosts =
      await mRepositorySimilarPosts.getSimilarPosts(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelSimilarPosts.code == 200) {
        emit(GetSimilarPostsResponse(
          modelSimilarPosts: modelSimilarPosts,
        ));
      } else {
        emit(GetSimilarPostsFailure(errorMessage: modelSimilarPosts.error ?? ModelError()));
      }
    } on SocketException {
      emit(GetSimilarPostsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(GetSimilarPostsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(GetSimilarPostsFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
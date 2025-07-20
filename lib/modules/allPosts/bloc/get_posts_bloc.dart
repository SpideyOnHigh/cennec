import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';
import '../model/model_posts.dart';
import '../repository/repository_posts.dart';

part 'get_posts_event.dart';
part 'get_posts_state.dart';

class GetPostsBloc extends Bloc<GetPostsEvent, GetPostsState> {
  GetPostsBloc({
    required RepositoryPosts repositoryPosts,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryPosts = repositoryPosts,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetPostsInitial()) {
    on<GetPosts>(_getPosts);
    on<LoadMorePosts>(_loadMorePosts);
  }

  final RepositoryPosts mRepositoryPosts;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getPosts(
      GetPosts event,
      Emitter<GetPostsState> emit,
      ) async {
    /// Emitting a GetPostsLoading state.
    emit(GetPostsLoading());
    try {
      final requestBody = {
        "order_by": event.orderBy ?? "interest_match_count",
        "sort": event.sort ?? "desc",
        "skip": event.skip ?? 0,
        "take": event.take ?? 5,
      };

      /// This is a way to handle the response from the API call.
      ModelPosts modelPosts = await mRepositoryPosts.getAllPosts(
        event.url,
        requestBody,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );

      if (modelPosts.code == 200) {
        emit(GetPostsResponse(
          modelPosts: modelPosts,
          isLoadingMore: false,
        ));
      } else {
        emit(GetPostsFailure(
            errorMessage: modelPosts.error ?? ModelError()));
      }
    } on SocketException {
      emit(GetPostsFailure(
          errorMessage: ModelError(
              generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(
          getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(GetPostsFailure(
            errorMessage: ModelError(
                generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(GetPostsFailure(
            errorMessage: ModelError(
                generalError:
                ValidationString.validationInternalServerIssue)));
      }
    }
  }

  void _loadMorePosts(
      LoadMorePosts event,
      Emitter<GetPostsState> emit,
      ) async {
    if (state is GetPostsResponse) {
      final currentState = state as GetPostsResponse;

      // Don't load more if already loading or no more data
      if (currentState.isLoadingMore ||
          (currentState.modelPosts.data?.length ?? 0) >= (currentState.modelPosts.total ?? 0)) {
        return;
      }

      emit(GetPostsResponse(
        modelPosts: currentState.modelPosts,
        isLoadingMore: true,
      ));

      try {
        final requestBody = {
          "order_by": event.orderBy ?? "interest_match_count",
          "sort": event.sort ?? "desc",
          "skip": currentState.modelPosts.data?.length ?? 0,
          "take": event.take ?? 5,
        };

        ModelPosts newModelPosts = await mRepositoryPosts.getAllPosts(
          event.url,
          requestBody,
          await mApiProvider.getHeaderValueWithToken(),
          mApiProvider,
          mClient,
        );

        if (newModelPosts.code == 200) {
          List<PostData> combinedPosts = [];
          combinedPosts.addAll(currentState.modelPosts.data ?? []);
          combinedPosts.addAll(newModelPosts.data ?? []);

          ModelPosts updatedModelPosts = ModelPosts(
            code: newModelPosts.code,
            message: newModelPosts.message,
            data: combinedPosts,
            count: newModelPosts.count,
            total: newModelPosts.total,
            currentPage: newModelPosts.currentPage,
            perPage: newModelPosts.perPage,
          );

          emit(GetPostsResponse(
            modelPosts: updatedModelPosts,
            isLoadingMore: false,
          ));
        } else {
          emit(GetPostsResponse(
            modelPosts: currentState.modelPosts,
            isLoadingMore: false,
          ));
        }
      } catch (e) {
        emit(GetPostsResponse(
          modelPosts: currentState.modelPosts,
          isLoadingMore: false,
        ));
      }
    }
  }
}
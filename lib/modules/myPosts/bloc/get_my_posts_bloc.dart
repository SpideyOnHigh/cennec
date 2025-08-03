import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/app_urls.dart';
import '../../core/utils/common_import.dart';
import '../model/model_delete_post.dart';
import '../model/model_my_posts.dart';
import '../repository/repository_my_posts.dart';

part 'get_my_posts_event.dart';
part 'get_my_posts_state.dart';

class GetMyPostsBloc extends Bloc<GetMyPostsEvent, GetMyPostsState> {
  GetMyPostsBloc({
    required RepositoryMyPosts repositoryMyPosts,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryMyPosts = repositoryMyPosts,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetMyPostsInitial()) {
    on<GetMyPosts>(_getMyPosts);
    on<LoadMoreMyPosts>(_loadMoreMyPosts);
    on<DeleteMyPost>(_deleteMyPost);  // Add this line

  }

  final RepositoryMyPosts mRepositoryMyPosts;
  final ApiProvider mApiProvider;
  final http.Client mClient;
  void _deleteMyPost(
      DeleteMyPost event,
      Emitter<GetMyPostsState> emit,
      ) async {
    if (state is GetMyPostsResponse) {
      final currentState = state as GetMyPostsResponse;

      emit(GetMyPostsDeleting(
        modelMyPosts: currentState.modelMyPosts,
        deletingPostId: event.postId,
      ));

      try {
        final requestBody = {"post_id": event.postId};

        ModelDeletePost deleteResult = await mRepositoryMyPosts.deletePost(
          event.url,
          requestBody,
          await mApiProvider.getHeaderValueWithToken(),
          mApiProvider,
          mClient,
        );

        if (deleteResult.code == 200) {
          emit(GetMyPostsDeleteSuccess(
            modelMyPosts: currentState.modelMyPosts,
            message: deleteResult.message ?? "Post deleted successfully",
          ));

          // Reload posts
          add(GetMyPosts(
            url: AppUrls.apiGetAllUserPosts,
            orderBy: "created_at",
            sort: "desc",
            skip: 1,
            take: 5,
          ));
        } else {
          emit(GetMyPostsDeleteFailure(
            modelMyPosts: currentState.modelMyPosts,
            errorMessage: deleteResult.error ?? ModelError(generalError: "Failed to delete post"),
          ));
        }
      } catch (e) {
        emit(GetMyPostsDeleteFailure(
          modelMyPosts: currentState.modelMyPosts,
          errorMessage: ModelError(generalError: "Failed to delete post"),
        ));
      }
    }
  }
  void _getMyPosts(
      GetMyPosts event,
      Emitter<GetMyPostsState> emit,
      ) async {
    /// Emitting a GetMyPostsLoading state.
    emit(GetMyPostsLoading());
    try {
      final requestBody = {
        "order_by": event.orderBy ?? "created_at",
        "sort": event.sort ?? "desc",
        "skip": event.skip ?? 1,
        "take": event.take ?? 5,
      };

      /// This is a way to handle the response from the API call.
      ModelMyPosts modelMyPosts = await mRepositoryMyPosts.getAllMyPosts(
        event.url,
        requestBody,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );

      if (modelMyPosts.code == 200) {
        emit(GetMyPostsResponse(
          modelMyPosts: modelMyPosts,
          isLoadingMore: false,
        ));
      } else {
        emit(GetMyPostsFailure(
            errorMessage: modelMyPosts.error ?? ModelError()));
      }
    } on SocketException {
      emit(GetMyPostsFailure(
          errorMessage: ModelError(
              generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      if (e.toString().contains(
          getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(GetMyPostsFailure(
            errorMessage: ModelError(
                generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(GetMyPostsFailure(
            errorMessage: ModelError(
                generalError:
                ValidationString.validationInternalServerIssue)));
      }
    }
  }

  void _loadMoreMyPosts(
      LoadMoreMyPosts event,
      Emitter<GetMyPostsState> emit,
      ) async {
    if (state is GetMyPostsResponse) {
      final currentState = state as GetMyPostsResponse;

      // Don't load more if already loading or no more data
      if (currentState.isLoadingMore ||
          (currentState.modelMyPosts.data?.length ?? 0) >= (currentState.modelMyPosts.total ?? 0)) {
        return;
      }

      emit(GetMyPostsResponse(
        modelMyPosts: currentState.modelMyPosts,
        isLoadingMore: true,
      ));

      try {
        final currentPage = currentState.modelMyPosts.currentPage ?? 1;
        final requestBody = {
          "order_by": event.orderBy ?? "created_at",
          "sort": event.sort ?? "desc",
          "skip": currentPage + 1,
          "take": event.take ?? 5,
        };

        ModelMyPosts newModelMyPosts = await mRepositoryMyPosts.getAllMyPosts(
          event.url,
          requestBody,
          await mApiProvider.getHeaderValueWithToken(),
          mApiProvider,
          mClient,
        );

        if (newModelMyPosts.code == 200) {
          List<MyPostData> combinedPosts = [];
          combinedPosts.addAll(currentState.modelMyPosts.data ?? []);
          combinedPosts.addAll(newModelMyPosts.data ?? []);

          ModelMyPosts updatedModelMyPosts = ModelMyPosts(
            code: newModelMyPosts.code,
            message: newModelMyPosts.message,
            data: combinedPosts,
            count: newModelMyPosts.count,
            total: newModelMyPosts.total,
            currentPage: newModelMyPosts.currentPage,
            perPage: newModelMyPosts.perPage,
          );

          emit(GetMyPostsResponse(
            modelMyPosts: updatedModelMyPosts,
            isLoadingMore: false,
          ));
        } else {
          emit(GetMyPostsResponse(
            modelMyPosts: currentState.modelMyPosts,
            isLoadingMore: false,
          ));
        }
      } catch (e) {
        emit(GetMyPostsResponse(
          modelMyPosts: currentState.modelMyPosts,
          isLoadingMore: false,
        ));
      }
    }
  }
}
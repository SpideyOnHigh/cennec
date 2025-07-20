import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';
import '../../repository/repository_add_user_post.dart';

part 'add_user_post_event.dart';
part 'add_user_post_state.dart';

class AddUserPostBloc extends Bloc<AddUserPostEvent, AddUserPostState> {
  AddUserPostBloc({
    required RepositoryAddUserPost repositoryAddUserPost,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAddUserPost = repositoryAddUserPost,
        mApiProvider = apiProvider,
        mClient = client,
        super(AddUserPostInitial()) {
    on<AddUserPost>(addUserPost);
  }

  final RepositoryAddUserPost mRepositoryAddUserPost;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void addUserPost(
      AddUserPost event,
      Emitter<AddUserPostState> emit,
      ) async {
    /// Emitting a AddUserPostLoading state.
    emit(AddUserPostLoading());
    try {
      /// Call the repository to add user post
      final response = await mRepositoryAddUserPost.addUserPost(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );

      if (response.code == 200) {
        emit(AddUserPostSuccess(
          message: response.message ?? "Post added successfully",
        ));
      } else {
        emit(AddUserPostFailure(
          errorMessage: response.error ?? ModelError(generalError: "Failed to add post"),
        ));
      }
    } on SocketException {
      emit(AddUserPostFailure(
        errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound),
      ));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(AddUserPostFailure(
          errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound),
        ));
      } else {
        emit(AddUserPostFailure(
          errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue),
        ));
      }
    }
  }
}


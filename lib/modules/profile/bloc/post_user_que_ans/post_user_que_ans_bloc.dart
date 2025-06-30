import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/profile/model/model_post_ans_response.dart';
import 'package:cennec/modules/profile/repository/repository_profile.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'post_user_que_ans_event.dart';
part 'post_user_que_ans_state.dart';

class PostUserQueAnsBloc extends Bloc<PostUserQueAnsEvent, PostUserQueAnsState> {
  PostUserQueAnsBloc({
    required RepositoryProfile repositoryProfile,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryProfile = repositoryProfile,
        mApiProvider = apiProvider,
        mClient = client,
        super(PostUserQueAnsInitial()) {
    on<PostUserQueAns>(updateProfile);
  }

  final RepositoryProfile mRepositoryProfile;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void updateProfile(
      PostUserQueAns event,
      Emitter<PostUserQueAnsState> emit,
      ) async {
    /// Emitting an ProfileLoading state.
    emit(PostUserQueAnsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelQueAnsPostResponse modelQueAnsPostResponse =
      await mRepositoryProfile.postQueAns(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelQueAnsPostResponse.success == true) {
        emit(PostUserQueAnsResponse(
          modelQueAnsPostResponse: modelQueAnsPostResponse,
        ));
      } else {
        emit(PostUserQueAnsFailure(errorMessage: modelQueAnsPostResponse.error ?? ModelError()));
      }
    } on SocketException {
      emit( PostUserQueAnsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  PostUserQueAnsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  PostUserQueAnsFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
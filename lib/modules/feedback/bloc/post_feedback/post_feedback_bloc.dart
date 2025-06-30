import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/feedback/model/model_feedback_response.dart';
import 'package:cennec/modules/feedback/repository/repository_feedback.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'post_feedback_event.dart';
part 'post_feedback_state.dart';

class PostFeedbackBloc extends Bloc<PostFeedbackEvent, PostFeedbackState> {
  PostFeedbackBloc({
    required RepositoryFeedback repositoryFeedback,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryFeedback = repositoryFeedback,
        mApiProvider = apiProvider,
        mClient = client,
        super(PostFeedbackInitial()) {
    on<PostFeedback>(_getFeedback);
  }

  final RepositoryFeedback mRepositoryFeedback;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getFeedback(
    PostFeedback event,
    Emitter<PostFeedbackState> emit,
  ) async {
    /// Emitting an AuthLoading state.
    emit(PostFeedbackLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelFeedbackResponse modelFeedbackResponse = await mRepositoryFeedback.postFeedback(
        event.url,
        event.body,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelFeedbackResponse.success == true) {
        emit(PostFeedbackResponse(
          modelFeedbackResponse: modelFeedbackResponse,
        ));
      } else {
        emit(PostFeedbackFailure(errorMessage: modelFeedbackResponse.error ?? ModelError()));
      }
    } on SocketException {
      emit(PostFeedbackFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error = $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(PostFeedbackFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(PostFeedbackFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}

import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/feedback/model/model_get_feedback_que.dart';
import 'package:cennec/modules/feedback/repository/repository_feedback.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'get_feedback_que_event.dart';
part 'get_feedback_que_state.dart';

class GetFeedbackQueBloc extends Bloc<GetFeedbackQueEvent, GetFeedbackQueState> {
  GetFeedbackQueBloc({
    required RepositoryFeedback repositoryFeedback,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryFeedback = repositoryFeedback,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetFeedbackQueInitial()) {
    on<GetFeedbackQue>(_getFeedback);
  }

  final RepositoryFeedback mRepositoryFeedback;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getFeedback(
      GetFeedbackQue event,
      Emitter<GetFeedbackQueState> emit,
      ) async {
    /// Emitting an AuthLoading state.
    emit(GetFeedbackQueLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelFeedbackQuestions modelFeedbackQuestions =
      await mRepositoryFeedback.getQuestions(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelFeedbackQuestions.success == true) {
        emit(GetFeedbackQueResponse(
          modelFeedbackQuestions: modelFeedbackQuestions,
        ));
      } else {
        emit(GetFeedbackQueFailure(errorMessage: modelFeedbackQuestions.error ?? ModelError()));
      }
    } on SocketException {
      emit(  GetFeedbackQueFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error = $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  GetFeedbackQueFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  GetFeedbackQueFailure(errorMessage: ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
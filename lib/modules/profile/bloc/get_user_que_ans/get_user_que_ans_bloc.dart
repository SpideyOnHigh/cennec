import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/profile/model/model_question_answer.dart';
import 'package:cennec/modules/profile/repository/repository_profile.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/common_import.dart';

part 'get_user_que_ans_event.dart';
part 'get_user_que_ans_state.dart';

class GetUserQueAnsBloc extends Bloc<GetUserQueAnsEvent, GetUserQueAnsState> {
  GetUserQueAnsBloc({
    required RepositoryProfile repositoryProfile,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryProfile = repositoryProfile,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetUserQueAnsInitial()) {
    on<GetUserQueAns>(updateProfile);
  }

  final RepositoryProfile mRepositoryProfile;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void updateProfile(
      GetUserQueAns event,
      Emitter<GetUserQueAnsState> emit,
      ) async {
    /// Emitting an ProfileLoading state.
    emit(GetUserQueAnsLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelQuestionAnswers modelQuestionAnswers =
      await mRepositoryProfile.getQuestionAnswers(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelQuestionAnswers.success == true) {
        emit(GetUserQueAnsResponse(
          modelQuestionAnswers: modelQuestionAnswers,
        ));
      } else {
        emit(GetUserQueAnsFailure(errorMessage: modelQuestionAnswers.error ?? ModelError()));
      }
    } on SocketException {
      emit( GetUserQueAnsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  GetUserQueAnsFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  GetUserQueAnsFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}
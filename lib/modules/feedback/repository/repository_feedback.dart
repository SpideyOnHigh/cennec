import 'package:cennec/modules/feedback/model/model_feedback_response.dart';
import 'package:cennec/modules/feedback/model/model_get_feedback_que.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositoryFeedback {
  static final RepositoryFeedback _repository = RepositoryFeedback._internal();

  /// `RepositoryFeedback()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryFeedback` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryFeedback() {
    return _repository;
  }

  /// A private constructor.
  RepositoryFeedback._internal();

  /// It calls the post method of the ApiProvider class and returns the response as a ModelUser object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelUser, ModelCommonAuthorised>
  Future<ModelFeedbackQuestions> getQuestions(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelFeedbackQuestions result = ModelFeedbackQuestions.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelFeedbackResponse> postFeedback(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelFeedbackResponse result = ModelFeedbackResponse.fromJson(jsonDecode(response));
    return result;
  }
}

import 'package:cennec/modules/connections/model/model_send_request.dart';
import 'package:cennec/modules/notifications/model/model_notification.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositoryNotification {
  static final RepositoryNotification _repository = RepositoryNotification._internal();

  /// `RepositoryConnections()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryConnections` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryNotification() {
    return _repository;
  }

  /// A private constructor.
  RepositoryNotification._internal();

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
  Future<ModelNotificationContent> getNotification(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelNotificationContent result = ModelNotificationContent.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelSendRequestResponse> sendRequest(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelSendRequestResponse result = ModelSendRequestResponse.fromJson(jsonDecode(response));
    return result;
  }
}

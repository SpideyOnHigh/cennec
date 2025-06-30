import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:cennec/modules/connections/model/model_fetch_user_detail.dart';
import 'package:cennec/modules/connections/model/model_my_connections.dart';
import 'package:cennec/modules/connections/model/model_my_favourites.dart';
import 'package:cennec/modules/connections/model/model_recommendations.dart';
import 'package:cennec/modules/connections/model/model_request_action.dart';
import 'package:cennec/modules/connections/model/model_send_request.dart';
import 'package:cennec/modules/dashboard/model/model_requests.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositoryConnections {
  static final RepositoryConnections _repository = RepositoryConnections._internal();

  /// `RepositoryConnections()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryConnections` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryConnections() {
    return _repository;
  }

  /// A private constructor.
  RepositoryConnections._internal();

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
  Future<ModelFetchUserDetail> getUserDetails(
    String url,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelFetchUserDetail result = ModelFetchUserDetail.fromJson(jsonDecode(response));
    return result;
  }


  Future<ModelMyFavourites> getFavourites(
    String url,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelMyFavourites result = ModelMyFavourites.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelRecommendations> getRecommendation(
    String url,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelRecommendations result = ModelRecommendations.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelMyConnections> getConnections(
    String url,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelMyConnections result = ModelMyConnections.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelRequests> getRequests(
    String url,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelRequests result = ModelRequests.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelSuccess> deleteConnection(
    String url,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callDeleteMethod(client, url,{}, header);
    ModelSuccess result = ModelSuccess.fromJson(jsonDecode(response));
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
  Future<ModelSuccess> removeUser(
    String url,
    Map<String, dynamic> body,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelSuccess result = ModelSuccess.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelSuccess> removeFavourite(
    String url,
    Map<String, dynamic> body,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelSuccess result = ModelSuccess.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelSuccess> addToFavourites(
    String url,
    Map<String, dynamic> body,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelSuccess result = ModelSuccess.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelRequestAction> postRequest(
    String url,
    Map<String, dynamic> body,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelRequestAction result = ModelRequestAction.fromJson(jsonDecode(response));
    return result;
  }
}

import 'package:cennec/modules/preferences/model/model_block.dart';
import 'package:cennec/modules/preferences/model/model_get_preference.dart';
import 'package:cennec/modules/preferences/model/model_report.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositoryPreferences {
  static final RepositoryPreferences _repository = RepositoryPreferences._internal();

  /// `RepositoryPreferences()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryPreferences` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryPreferences() {
    return _repository;
  }

  /// A private constructor.
  RepositoryPreferences._internal();

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
  Future<ModelPreferences> getPreferences(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelPreferences result = ModelPreferences.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelBlockResponse> blockUser(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelBlockResponse result = ModelBlockResponse.fromJson(jsonDecode(response));
    return result;
  }
  Future<ModelPreferences> postPreferences(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelPreferences result = ModelPreferences.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelReport> reportUser(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelReport result = ModelReport.fromJson(jsonDecode(response));
    return result;
  }

}

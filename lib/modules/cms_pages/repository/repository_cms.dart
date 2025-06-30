import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositoryGetCmsPage {
  static final RepositoryGetCmsPage _repository = RepositoryGetCmsPage._internal();

  /// `RepositoryGetCmsPage()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryGetCmsPage` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryGetCmsPage() {
    return _repository;
  }

  /// A private constructor.
  RepositoryGetCmsPage._internal();

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
  Future<String> getPage(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callGetMethodForTAC(client, url, header);
    String result = response;
    return result;
  }  
  
  Future<ModelSuccess> postUserAcceptedPolicy(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url,{}, header);
    ModelSuccess result = ModelSuccess.fromJson(jsonDecode(response));
    return result;
  }

}

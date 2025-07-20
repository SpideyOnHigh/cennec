import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';
import '../model/similar_post_model.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelSimilarPosts
class RepositorySimilarPosts {
  static final RepositorySimilarPosts _repository = RepositorySimilarPosts._internal();

  /// `RepositorySimilarPosts()` is a factory constructor that returns a singleton instance of the
  /// `RepositorySimilarPosts` class
  ///
  /// Returns:
  ///   The repository
  factory RepositorySimilarPosts() {
    return _repository;
  }

  /// A private constructor.
  RepositorySimilarPosts._internal();

  /// It calls the post method of the ApiProvider class and returns the response as a ModelSimilarPosts object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   ModelSimilarPosts
  Future<ModelSimilarPosts> getSimilarPosts(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelSimilarPosts result = ModelSimilarPosts.fromJson(jsonDecode(response));
    return result;
  }

  /// It calls the get method of the ApiProvider class and returns the response as a ModelSimilarPosts object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   ModelSimilarPosts
  Future<ModelSimilarPosts> getSimilarPostsByGet(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelSimilarPosts result = ModelSimilarPosts.fromJson(jsonDecode(response));
    return result;
  }

  /// It calls the post method of the ApiProvider class for similar posts with filters
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request containing filter parameters.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   ModelSimilarPosts
  Future<ModelSimilarPosts> getSimilarPostsWithFilters(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelSimilarPosts result = ModelSimilarPosts.fromJson(jsonDecode(response));
    return result;
  }

  /// It calls the post method of the ApiProvider class for getting recommended similar posts
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request containing user preferences.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   ModelSimilarPosts
  Future<ModelSimilarPosts> getRecommendedSimilarPosts(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelSimilarPosts result = ModelSimilarPosts.fromJson(jsonDecode(response));
    return result;
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';
import '../model/model_my_posts.dart';
import '../model/model_delete_post.dart';

/// This class used to API and bloc connection
/// This class is used to call the my posts api and return the response in the form of ModelMyPosts
class RepositoryMyPosts {
  static final RepositoryMyPosts _repository = RepositoryMyPosts._internal();

  /// `RepositoryMyPosts()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryMyPosts` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryMyPosts() {
    return _repository;
  }

  /// A private constructor.
  RepositoryMyPosts._internal();

  /// It calls the post method of the ApiProvider class and returns the response as a ModelMyPosts object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   ModelMyPosts
  Future<ModelMyPosts> getAllMyPosts(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelMyPosts result = ModelMyPosts.fromJson(jsonDecode(response));
    return result;
  }

  /// It calls the post method of the ApiProvider class and returns the response as a ModelDeletePost object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   ModelDeletePost
  Future<ModelDeletePost> deletePost(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelDeletePost result = ModelDeletePost.fromJson(jsonDecode(response));
    return result;
  }
}
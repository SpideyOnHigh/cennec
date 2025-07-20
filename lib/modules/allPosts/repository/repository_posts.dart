import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';
import '../model/model_posts.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelPosts
class RepositoryPosts {
  static final RepositoryPosts _repository = RepositoryPosts._internal();

  /// `RepositoryPosts()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryPosts` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryPosts() {
    return _repository;
  }

  /// A private constructor.
  RepositoryPosts._internal();

  /// It calls the post method of the ApiProvider class and returns the response as a ModelPosts object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   ModelPosts
  Future<ModelPosts> getAllPosts(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelPosts result = ModelPosts.fromJson(jsonDecode(response));
    return result;
  }
}
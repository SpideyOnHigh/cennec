import 'package:cennec/modules/interests/model/model_add_or_remove_interests.dart';
import 'package:cennec/modules/interests/model/model_interests.dart';
import 'package:cennec/modules/interests/model/model_recommendations_of_interests.dart';
import 'package:cennec/modules/interests/model/model_update_interests.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositoryInterests {
  static final RepositoryInterests _repository = RepositoryInterests._internal();

  /// `RepositoryInterests()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryInterests` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryInterests() {
    return _repository;
  }

  /// A private constructor.
  RepositoryInterests._internal();

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
  Future<ModelInterestsList> getInterests(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelInterestsList result = ModelInterestsList.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelRecommendationsOfInterest> getRecommendations(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelRecommendationsOfInterest result = ModelRecommendationsOfInterest.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelUpdateInterests> updateInterests(
      String url,
      Map<String,dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url,body, header);
    ModelUpdateInterests result = ModelUpdateInterests.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelAddOrRemoveInterests> addRemoveInts(
      String url,
      Map<String,dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url,body, header);
    ModelAddOrRemoveInterests result = ModelAddOrRemoveInterests.fromJson(jsonDecode(response));
    return result;
  }


}

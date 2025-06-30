import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:cennec/modules/connections/model/model_get_images.dart';
import 'package:cennec/modules/profile/model/ImageUploadResponse.dart';
import 'package:cennec/modules/profile/model/model_post_ans_response.dart';
import 'package:cennec/modules/profile/model/model_question_answer.dart';
import 'package:cennec/modules/profile/model/model_updated_profile_data.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';
import '../model/model_edit_profile_pref.dart';
import '../model/profile_picture_model.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositoryProfile {
  static final RepositoryProfile _repository = RepositoryProfile._internal();

  /// `RepositoryConnections()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryConnections` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryProfile() {
    return _repository;
  }

  /// A private constructor.
  RepositoryProfile._internal();

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
  Future<ModelUserEditProfilePrefs> getProfilePref(
    String url,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelUserEditProfilePrefs result = ModelUserEditProfilePrefs.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelGetImages> getUserProfilePicture(
    String url,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelGetImages result = ModelGetImages.fromJson(jsonDecode(response));
    return result;
  }

  Future<ImageUploadResponse> callPostMethodWithImage(
      String url,
      Map<String, String> header,
      Map<String, String> body,
      ApiProvider mApiProvider,
      http.Client client,
      List<ProfilePictureModel> imageList
      ) async {
    final response = await mApiProvider.callPostMethodWithImage(client, url, body, header, imageList);
    ImageUploadResponse result = ImageUploadResponse.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelQuestionAnswers> getQuestionAnswers(
    String url,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelQuestionAnswers result = ModelQuestionAnswers.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelUpdatedProfileData> updateProfileData(
    String url,
    Map<String, dynamic> body,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelUpdatedProfileData result = ModelUpdatedProfileData.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelQueAnsPostResponse> postQueAns(
    String url,
    Map<String, dynamic> body,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelQueAnsPostResponse result = ModelQueAnsPostResponse.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelSuccess> setDefaultProfilePic(
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
}

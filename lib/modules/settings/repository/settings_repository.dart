import 'package:cennec/modules/settings/model/model_edit_user_settings.dart';
import 'package:cennec/modules/settings/model/model_get_user_settings.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositorySettings {
  static final RepositorySettings _repository = RepositorySettings._internal();

  /// `RepositorySettings()` is a factory constructor that returns a singleton instance of the
  /// `RepositorySettings` class
  ///
  /// Returns:
  ///   The repository
  factory RepositorySettings() {
    return _repository;
  }

  /// A private constructor.
  RepositorySettings._internal();

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
  Future<ModelGetUserSettings> getUserSettings(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    ModelGetUserSettings result = ModelGetUserSettings.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelEditSettingsResponse> editUserSettings(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelEditSettingsResponse result = ModelEditSettingsResponse.fromJson(jsonDecode(response));
    return result;
  }

}

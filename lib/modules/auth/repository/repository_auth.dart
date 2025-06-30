import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:cennec/modules/auth/model/model_login.dart';
import 'package:cennec/modules/auth/model/model_logout.dart';
import 'package:cennec/modules/auth/model/model_registeration.dart';
import 'package:cennec/modules/auth/model/model_sign_up_inv.dart';
import 'package:cennec/modules/auth/model/model_verify_sign_up_otp.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositoryAuth {
  static final RepositoryAuth _repository = RepositoryAuth._internal();

  /// `RepositoryAuth()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryAuth` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryAuth() {
    return _repository;
  }

  /// A private constructor.
  RepositoryAuth._internal();

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
  Future<ModelLogin> callPostMethod(
    String url,
    Map<String, dynamic> body,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelLogin result = ModelLogin.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelSignUpInvCode> callVerifySignUpInvCode(
    String url,
    Map<String, dynamic> body,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelSignUpInvCode result = ModelSignUpInvCode.fromJson(jsonDecode(response));
    return result;
  }


Future<ModelOtpResetLink> fetchResetLink(
    String url,
    Map<String, dynamic> body,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelOtpResetLink result = ModelOtpResetLink.fromJson(jsonDecode(response));
    return result;
  }


  Future<ModelSuccess> changePassword(
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

  Future<ModelSuccess> deleteAccount(
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

  Future<ModelRegistration> registerUser(
    String url,
    Map<String, dynamic> body,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelRegistration result = ModelRegistration.fromJson(jsonDecode(response));
    return result;
  }

  Future<ModelLogoutSuccess> callLogout(
    String url,
    Map<String, dynamic> body,
    Map<String, String> header,
    ApiProvider mApiProvider,
    http.Client client,
  ) async {
    final response = await mApiProvider.callPostMethod(client, url, body, header);
    ModelLogoutSuccess result = ModelLogoutSuccess.fromJson(jsonDecode(response));
    return result;
  }
}

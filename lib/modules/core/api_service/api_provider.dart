import 'package:cennec/app.dart';
import 'package:cennec/modules/auth/model/model_change_pwd.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:cennec/modules/core/common/widgets/toast_controller.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_urls.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import '../../profile/model/profile_picture_model.dart';
import '../utils/common_import.dart';

/// A [ApiProvider] class is used to network API call
/// Allows all classes implementing [Client] to be mutually composable.
class ApiProvider {
  static final ApiProvider _singletonApiProvider = ApiProvider._internal();

  factory ApiProvider() {
    return _singletonApiProvider;

  }

  ApiProvider._internal();

  Future<Map<String, String>> getHeaderValue() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var version = packageInfo.version;
    var acceptType = AppConfig.xAcceptDeviceAndroid;
    if (kIsWeb) {
      acceptType = AppConfig.xAcceptDeviceWeb;
    } else if (Platform.isIOS) {
      acceptType = AppConfig.xAcceptDeviceIOS;
    }
    return {
      AppConfig.xAccept: AppConfig.xApplicationJson,
      AppConfig.xContentType: AppConfig.xApplicationJson,
    };
  }

  Future<Map<String, String>> getHeaderValueWithToken() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var version = packageInfo.version;
    var acceptType = AppConfig.xAcceptDeviceAndroid;
    if (kIsWeb) {
      acceptType = AppConfig.xAcceptDeviceWeb;
    } else if (Platform.isIOS) {
      acceptType = AppConfig.xAcceptDeviceIOS;
    }
    return {
      // AppConfig.xAcceptAppVersion: version,
      // AppConfig.xAcceptType: acceptType,
      AppConfig.xContentType: AppConfig.xApplicationJson,
      AppConfig.xAccept: AppConfig.xApplicationJson,
      AppConfig.xAuthorization: 'Bearer ${PreferenceHelper.getString(PreferenceHelper.userToken)}',
    };
  }

  Future callPostMethod(http.Client client, String url, Map<String, dynamic> params, Map<String, String> mHeader) async {
    var baseUrl = Uri.parse(url);
    printWrapped('Request Url==>$baseUrl');
    printWrapped('Request Method==>Post');
    printWrapped('Request Header==>$mHeader');
    printWrapped('Request Body==>${jsonEncode(params)}');
    bool onceCalledInCatch = false;
    try {
      if (MyAppState.isConnected.value) {
        return await client.post(baseUrl, body: jsonEncode(params), headers: mHeader).timeout(const Duration(seconds: 120)).then((Response response) {
          return getResponse(response);
        });
      } else {
        return '{"status":false,"message":"","error":{"failed" : "${ValidationString.validationCheckInternetConnectivity}"}}';
      }
    } catch (e) {
      printWrapped("error in get === ${e.toString()}");
      if (e.toString().contains('Connection closed before full header was received')) {
        if (MyAppState.isConnected.value && !onceCalledInCatch) {
          onceCalledInCatch = true;
          return await client.post(baseUrl, body: jsonEncode(params), headers: mHeader).timeout(const Duration(seconds: 120)).then((Response response) {
            return getResponse(response);
          });
        } else {
          return '{"status":false,"message":"","error":{"failed" : "${ValidationString.validationCheckInternetConnectivity}"}}';
        }
      }
    }
  }

  Future callDeleteMethod(http.Client client, String url, Map<String, dynamic> params, Map<String, String> mHeader) async {
    var baseUrl = Uri.parse(url);
    printWrapped('Request Url==>$baseUrl');
    printWrapped('Request Method==>Delete');
    printWrapped('Request Header==>$mHeader');
    printWrapped('Request Body==>$params');
    bool onceCalledInCatch = false;
    try {
      if (MyAppState.isConnected.value) {
        return await client.delete(baseUrl, body: jsonEncode(params), headers: mHeader).timeout(const Duration(seconds: 120)).then((Response response) {
          return getResponse(response);
        });
      } else {
        return '{"status":false,"message":"","error":{"failed" : "${ValidationString.validationCheckInternetConnectivity}"}}';
      }
    } catch (e) {
      printWrapped("error in get === ${e.toString()}");
      if (e.toString().contains('Connection closed before full header was received')) {
        if (MyAppState.isConnected.value && !onceCalledInCatch) {
          onceCalledInCatch = true;
          return await client.delete(baseUrl, body: jsonEncode(params), headers: mHeader).timeout(const Duration(seconds: 120)).then((Response response) {
            return getResponse(response);
          });
        } else {
          return '{"status":false,"message":"","error":{"failed" : "${ValidationString.validationCheckInternetConnectivity}"}}';
        }
      }
    }
  }

  Future callPutMethod(http.Client client, String url, Map<String, dynamic> params, Map<String, String> mHeader) async {
    var baseUrl = Uri.parse(url);
    printWrapped('Request Url==>$baseUrl');
    printWrapped('Request Method==>Put');
    printWrapped('Request Header==>$mHeader');
    printWrapped('Request Body==>$params');
    return await client.put(baseUrl, body: jsonEncode(params), headers: mHeader).then((Response response) {
      return getResponse(response);
    });
  }

  Future callPutMethodWithImage(http.Client client, String url, Map<String, String> params, Map<String, String> mHeader, String image) async {
    var baseUrl = Uri.parse(url);
    printWrapped('Request Url==>$baseUrl');
    printWrapped('Request Method==>Post');
    printWrapped('Request Header==>$mHeader');
    printWrapped('Request Body==>$params');
    printWrapped('Request Body==>$image');
    var request = http.MultipartRequest('PUT', baseUrl);
    request.files.add(await http.MultipartFile.fromPath("profile_image", image));
    request.headers.addAll(mHeader);
    params.forEach((k, v) {
      request.fields[k] = v;
    });
    var streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return getResponse(response);
  }

  Future callPostMethodWithImage(
      http.Client client, String url, Map<String, String> params, Map<String, String> mHeader, List<ProfilePictureModel> image) async {
    var baseUrl = Uri.parse(url);
    printWrapped('Request Url==>$baseUrl');
    printWrapped('Request Method==>Post');
    printWrapped('Request Header==>$mHeader');
    printWrapped('Request Body==>$params');
    printWrapped('Request Body==>$image');
    var request = http.MultipartRequest('POST', baseUrl);
    for (int i = 0; i < image.length; i++) {
      if (image[i].imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath("image_${i + 1}", image[i].imageFile!.path));
        printWrapped("===== data$i = image[i].containsDatabaseImage = ${image[i].containsDatabaseImage}");
        printWrapped("===== data$i = image[i].isUpdate = ${image[i].isUpdate}");
        if (image[i].containsDatabaseImage == true && image[i].isUpdate == true) {
          printWrapped("contains data base image");
          // request.headers["deleted_images[${i + 1}]"] = image[i].imageId.toString();
          request.fields["deleted_images[${i + 1}]"] = image[i].imageId.toString();
        }
      }
    }
    printWrapped("req field = ${request.fields.toString()}");
    request.headers.addAll(mHeader);
    params.forEach((k, v) {
      request.fields[k] = v;
    });
    var streamedResponse = await request.send();
    printWrapped("--request headers = ${request.headers.toString()}");
    final response = await http.Response.fromStream(streamedResponse);
    return getResponse(response);
  }

  Future callGetMethod(http.Client client, String url, Map<String, String> mHeader) async {
    bool onceCalledInCatch = false;
    var baseUrl = Uri.parse(url);
    printWrapped('Request Url==>$baseUrl');
    printWrapped('Request Method==>Get');
    printWrapped('Request Header==>$mHeader');
    try {
      if (MyAppState.isConnected.value) {
        return await client.get(baseUrl, headers: mHeader).timeout(const Duration(seconds: 120)).then((Response response) {
          if (url != AppUrls.apiGetInterests) {
            printWrapped('response body==: ${response.body}\nstatus code==: ${response.statusCode}');
          }
          return getResponse(response);
        });
      } else {
        return '{"status":false,"message":"","error":{"failed" : "${ValidationString.validationCheckInternetConnectivity}"}}';
      }
    } catch (e) {
      printWrapped("error in get === ${e.toString()}");
      if (e.toString().contains('Connection closed before full header was received')) {
        if (MyAppState.isConnected.value && !onceCalledInCatch) {
          onceCalledInCatch = true;
          return await client.get(baseUrl, headers: mHeader).timeout(const Duration(seconds: 120)).then((Response response) {
            if (url != AppUrls.apiGetInterests) {
              printWrapped('response body==: ${response.body}\nstatus code==: ${response.statusCode}');
            }
            return getResponse(response);
          });
        } else {
          return '{"status":false,"message":"","error":{"failed" : "${ValidationString.validationCheckInternetConnectivity}"}}';
        }
      }
    }
  }

  String processLargeString(String largeString) {
    const chunkSize = 1000; // Define a reasonable chunk size
    StringBuffer stringBuffer = StringBuffer(); // Use StringBuffer to build the final string

    for (int i = 0; i < largeString.length; i += chunkSize) {
      String chunk = largeString.substring(
        i,
        i + chunkSize > largeString.length ? largeString.length : i + chunkSize,
      );

      // Append the chunk to the StringBuffer
      stringBuffer.write(chunk);
    }

    // Return the final combined string
    return stringBuffer.toString();
  }

  Future<String> callGetMethodForTAC(http.Client client, String url, Map<String, String> mHeader) async {
    var baseUrl = Uri.parse(url);
    printWrapped('Request Url==>$baseUrl');
    printWrapped('Request Method==>Get');
    printWrapped('Request Header==>$mHeader');
    try {
      final uri = Uri.parse(url);
      final response = await http.get(baseUrl);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success']) {
          String largeString = responseData['data']['content'];

          // Process the large string in chunks
          String finalString = processLargeString(largeString);
          print('finalString: $finalString');
          return finalString;
        } else {
          print('Error: ${responseData['error']}');
          return "";
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
        return "";
      }
    } catch (e) {
      printWrapped("eee = $e");
      return "";
    }
  }

  Future getResponse(var response) async {
    printWrapped("response = ${response.body} \n status = ${response.statusCode}");
    final int statusCode = response.statusCode!;
    if (statusCode == 500 || statusCode == 502) {
      // return response.body;
      return '{"status":false,"message":"","error":{"failed" : "500 Internal server error"}}';
    } else if (statusCode == 401) {
      String? currentPath;
      NavigatorKey.navigatorKey.currentState!.popUntil((route) {
        currentPath = route.settings.name;
        return true;
      });
      if (currentPath != AppRoutes.routesSplash) {
        PreferenceHelper.clear();
        NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.routesSplash, (route) => false);
        ToastController.showToast(getNavigatorKeyContext(), 'User Logged out from device.', false);
      }
      ModelCommonAuthorised streams = ModelCommonAuthorised.fromJson(json.decode(response.body));
      return '{"status":false,"message":"${streams.message}"}';
    } else if (statusCode == 403) {
      return response.body;
    } else if (statusCode == 405) {
      String error = ValidationString.validationThisMethodNotAllowed;
      return '{"status":false,"message":"$error"}';
    } else if (statusCode == 404) {
      String error = "ValidationString.validationNotFound";
      return '{"status":false,"message":"$error"}';
    } else if (statusCode == 503) {
      String error = "ValidationString.validationServiceTemporaryUnAvailable";
      return '{"status":false,"message":"$error"}';
    } else if (statusCode == 400) {
      return response.body;
    } else if (statusCode < 200 || statusCode > 404) {
      String error = response.headers!['message'].toString();
      return response.body;
    }
    return response.body;
  }

  Future<ModelSuccess> callPostMultipartMethod(String url, Map<String, dynamic> params, Map<String, String> mHeader, List<ModelMultiPartFile> mFiles) async {
    var baseUrl = Uri.parse(url);
    printWrapped('Method---POST-Multipart mobile');
    printWrapped('baseUrl--$baseUrl');
    printWrapped('mHeader--${mHeader.toString()}');
    printWrapped('requestBody--${jsonEncode(params)}');

    var request = http.MultipartRequest('POST', baseUrl);
    for (int i = 0; i < mFiles.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        mFiles[i].filePath,
      ));
      printWrapped('requestFiles--$i--${mFiles[i].apiKey}-----${mFiles[i].filePath}');
      printWrapped('requestFiles--size--${await File(mFiles[i].filePath).length()}');
    }
    request.headers.addAll(mHeader);
    /*params.forEach((k, v) {
      request.fields[k] = '$v';
    });*/
    var streamedResponse = await request.send().timeout(const Duration(seconds: 120));
    final response = await http.Response.fromStream(streamedResponse);
    printWrapped('response of ----$baseUrl \nresponse body==: ${response.body}\nstatus code==: ${response.statusCode}');

    return await getResponse(response);
  }
}

class ModelMultiPartFile {
  String filePath;
  String apiKey;

  ModelMultiPartFile({required this.filePath, required this.apiKey});
}

import 'dart:convert';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/core/api_service/preference_helper.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/common_import.dart';

// Response model for add user post
class ModelAddUserPostResponse {
  final int? code;
  final String? message;
  final ModelError? error;
  final dynamic data;

  ModelAddUserPostResponse({
    this.code,
    this.message,
    this.error,
    this.data,
  });

  factory ModelAddUserPostResponse.fromJson(Map<String, dynamic> json) {
    return ModelAddUserPostResponse(
      code: json['code'],
      message: json['message'],
      data: json['data'],
    );
  }
}

class RepositoryAddUserPost {
  Future<ModelAddUserPostResponse> addUserPost(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider apiProvider,
      http.Client client,
      ) async {
    try {
      printWrapped("Add User Post URL: $url");
      printWrapped("Add User Post Body: $body");
      printWrapped("Add User Post Headers: $header");

      final response = await client.post(
        Uri.parse(url),
        headers: header,
        body: jsonEncode(body),
      );

      printWrapped("Add User Post Response Status: ${response.statusCode}");
      printWrapped("Add User Post Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return ModelAddUserPostResponse.fromJson(responseData);
      } else {
        // Handle error response
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return ModelAddUserPostResponse(
          code: response.statusCode,
          error: ModelError.fromJson(errorData),
        );
      }
    } catch (e) {
      printWrapped("Add User Post Repository Error: $e");
      return ModelAddUserPostResponse(
        error: ModelError(generalError: "Failed to add post: ${e.toString()}"),
      );
    }
  }
}
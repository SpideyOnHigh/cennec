import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelDeletePost {
  int? code;
  String? message;
  ModelError? error;

  ModelDeletePost({
    this.code,
    this.message,
    this.error,
  });

  ModelDeletePost.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    error = json['error'] != null ? ModelError.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (error != null) {
      data['error'] = error!.toJson();
    }
    return data;
  }
}
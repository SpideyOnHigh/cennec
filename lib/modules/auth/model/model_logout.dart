import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelLogoutSuccess {
  bool? success;
  String? message;
  ModelError? error;


  ModelLogoutSuccess({this.success, this.message,this.error});

  ModelLogoutSuccess.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ?  ModelError.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    return data;
  }
}
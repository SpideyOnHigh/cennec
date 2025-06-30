import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelSuccess {
  bool? success;
  String? message;
  ModelError? error;


  ModelSuccess({this.success, this.message,this.error});

  ModelSuccess.fromJson(Map<String, dynamic> json) {
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

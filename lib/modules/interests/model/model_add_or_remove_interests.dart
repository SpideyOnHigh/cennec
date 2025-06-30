import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelAddOrRemoveInterests {
  bool? success;
  String? message;
  ModelError? error;
  Data? data;

  ModelAddOrRemoveInterests(
      {this.success, this.message, this.error, this.data});

  ModelAddOrRemoveInterests.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ?  ModelError.fromJson(json['error']) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  int? interestId;

  Data({this.userId, this.interestId});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    interestId = json['interest_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['interest_id'] = interestId;
    return data;
  }
}

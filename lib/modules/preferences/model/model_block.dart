import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelBlockResponse {
  bool? success;
  String? message;
  ModelError? error;
  Data? data;

  ModelBlockResponse({this.success, this.message, this.error, this.data});

  ModelBlockResponse.fromJson(Map<String, dynamic> json) {
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
  int? blockedByUserId;
  int? blockedUserId;
  String? blockedStatus;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.blockedByUserId,
        this.blockedUserId,
        this.blockedStatus,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    blockedByUserId = json['blocked_by_user_id'];
    blockedUserId = json['blocked_user_id'];
    blockedStatus = json['blocked_status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['blocked_by_user_id'] = blockedByUserId;
    data['blocked_user_id'] = blockedUserId;
    data['blocked_status'] = blockedStatus;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}

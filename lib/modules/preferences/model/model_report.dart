import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelReport {
  bool? success;
  String? message;
  ModelError? error;
  Data? data;

  ModelReport({this.success, this.message, this.error, this.data});

  ModelReport.fromJson(Map<String, dynamic> json) {
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
  int? reportedByUserId;
  int? reportedUserId;
  String? reason;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.reportedByUserId,
        this.reportedUserId,
        this.reason,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    reportedByUserId = json['reported_by_user_id'];
    reportedUserId = json['reported_user_id'];
    reason = json['reason'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reported_by_user_id'] = reportedByUserId;
    data['reported_user_id'] = reportedUserId;
    data['reason'] = reason;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}

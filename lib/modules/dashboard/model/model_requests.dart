import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/notifications/model/model_notification.dart';

class ModelRequests {
  bool? success;
  String? message;
  ModelError? error;
  int? requestCount;
  List<NotificationData>? data;

  ModelRequests(
      {this.success, this.message, this.error, this.requestCount, this.data});

  ModelRequests.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ? ModelError.fromJson(json['error']) : null;
    requestCount = json['request_count'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['error'] = error;
    data['request_count'] = requestCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RequestModel {
  int? id;
  int? fromUserId;
  int? toUserId;
  String? requestComment;
  String? requestStatus;
  String? createdAt;
  String? fromUserImage;

  RequestModel(
      {this.id,
        this.fromUserId,
        this.toUserId,
        this.requestComment,
        this.requestStatus,
        this.createdAt,
        this.fromUserImage});

  RequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    requestComment = json['request_comment'];
    requestStatus = json['request_status'];
    createdAt = json['created_at'];
    fromUserImage = json['from_user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['from_user_id'] = fromUserId;
    data['to_user_id'] = toUserId;
    data['request_comment'] = requestComment;
    data['request_status'] = requestStatus;
    data['created_at'] = createdAt;
    data['from_user_image'] = fromUserImage;
    return data;
  }
}

import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelNotificationContent {
  bool? success;
  String? message;
  ModelError? error;
  List<NotificationData>? data;

  ModelNotificationContent({this.success, this.message, this.error, this.data});

  ModelNotificationContent.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ? ModelError.fromJson(json['error']) : null;
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  int? id;
  int? userId;
  int? fromUserId;
  String? type;
  String? message;
  String? requestComment;
  String? userProfileImage;
  int? isRead;
  String? createdAt;
  String? updatedAt;
  String? fromUser;

  NotificationData({this.id, this.userId,this.fromUserId, this.type, this.message, this.requestComment, this.userProfileImage, this.isRead, this.createdAt, this.updatedAt,this.fromUser});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fromUserId = json['from_user_id'];
    type = json['type'];
    message = json['message'];
    requestComment = json['request_comment'];
    userProfileImage = json['user_profile_image'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fromUser = json['from_user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['message'] = message;
    data['request_comment'] = requestComment;
    data['user_profile_image'] = userProfileImage;
    data['is_read'] = isRead;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['from_user_name'] = fromUser;
    return data;
  }
}

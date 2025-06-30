import 'package:cennec/modules/connections/model/model_recommendations.dart';

import '../../core/api_service/error_model.dart';

class MessageListResponse {
  MessageListResponse({
    required this.success,
    required this.message,
    this.error,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final ModelError? error;
  late final List<MessageList> data;
  MessageListResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    error = (json['error'] != null ?  ModelError.fromJson(json['error']) : null);
    data = List.from(json['data']).map((e)=>MessageList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['success'] = success;
    result['message'] = message;
    result['error'] = error;
    result['data'] = data.map((e) => e.toJson()).toList();
    return result;
  }

}

class MessageList {
  MessageList({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.contact,
    required this.fcmToken,
    required this.emailVerifiedAt,
    required this.invitationCodeId,
    required this.userStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.latestMessageTime,
    required this.defaultProfilePicture,
  });
  late final int? id;
  late final String? name;
  late final String? username;
  late final String? email;
  late final String? contact;
  late final String? fcmToken;
  late final String? emailVerifiedAt;
  late final int? invitationCodeId;
  late final String? userStatus;
  late final String? createdAt;
  late final String? updatedAt;
  late final String? deletedAt;
  late final String? latestMessageTime;
  late final String? defaultProfilePicture;
  late final List<ProfileImages>? profileImages;

  MessageList.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    contact = json['contact'];
    fcmToken = json['fcm_token'];
    emailVerifiedAt = json['email_verified_at'];
    invitationCodeId = json['invitation_code_id'];
    userStatus = json['user_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    latestMessageTime = json['latest_message_time'];
    defaultProfilePicture = json['default_profile_picture'];
    // if (profileImages != null) {
    //   json['profile_images'] =
    //       profileImages!.map((v) => v.toJson()).toList();
    // }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['contact'] = contact;
    data['fcm_token'] = fcmToken;
    data['email_verified_at'] = emailVerifiedAt;
    data['invitation_code_id'] = invitationCodeId;
    data['user_status'] = userStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['latest_message_time'] = latestMessageTime;
    data['default_profile_picture'] = defaultProfilePicture;
    return data;
  }
}
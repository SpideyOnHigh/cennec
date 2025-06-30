import 'package:cennec/modules/core/api_service/error_model.dart';

import '../../connections/model/model_recommendations.dart';

class ModelLogin {
  bool? success;
  String? message;
  ModelError? error;
  LoginDetail? data;

  ModelLogin({this.success, this.message,this.error, this.data});

  ModelLogin.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ?  ModelError.fromJson(json['error']) : null;
    data = json['data'] != null ? LoginDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginDetail {
  String? token;
  bool? hasInterests = false;
  UserData? userData;

  LoginDetail({this.token,this.hasInterests = false, this.userData});

  LoginDetail.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    hasInterests = json['has_interests'];
    userData = json['userData'] != null
        ? UserData.fromJson(json['userData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['has_interests'] = hasInterests;
    if (userData != null) {
      data['userData'] = userData!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? name;
  String? username;
  String? email;
  String? contact;
  String? appleId;
  String? googleId;
  String? fcmToken;
  String? emailVerifiedAt;
  int? invitationCodeId;
  String? emailOtp;
  String? userStatus;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool? hasReadAboutUs;
  bool? hasReadGuidelines;
  List<ProfileImages>? profileImages;
  String? defaultProfilePic;


  UserData(
      {this.id,
        this.name,
        this.username,
        this.email,
        this.contact,
        this.appleId,
        this.googleId,
        this.fcmToken,
        this.emailVerifiedAt,
        this.invitationCodeId,
        this.emailOtp,
        this.userStatus,
        this.createdAt,
        this.profileImages,
        this.updatedAt,
        this.hasReadAboutUs = false,
        this.hasReadGuidelines = false,
        this.deletedAt,
        this.defaultProfilePic
      });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    contact = json['contact'];
    appleId = json['apple_id'];
    googleId = json['google_id'];
    fcmToken = json['fcm_token'];
    emailVerifiedAt = json['email_verified_at'];
    invitationCodeId = json['invitation_code_id'];
    emailOtp = json['email_otp'];
    userStatus = json['user_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    hasReadAboutUs = json['is_accept_about_us'];
    hasReadGuidelines = json['is_accept_guidelines'];
    deletedAt = json['deleted_at'];
    defaultProfilePic = json['default_profile_picture'];
    if (json['profile_pictures'] != null) {
      profileImages = <ProfileImages>[];
      json['profile_pictures'].forEach((v) {
        profileImages!.add(ProfileImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['contact'] = contact;
    data['apple_id'] = appleId;
    data['google_id'] = googleId;
    data['fcm_token'] = fcmToken;
    data['email_verified_at'] = emailVerifiedAt;
    data['invitation_code_id'] = invitationCodeId;
    data['email_otp'] = emailOtp;
    data['user_status'] = userStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['is_accept_about_us'] = hasReadAboutUs;
    data['is_accept_guidelines'] = hasReadGuidelines;
    data['default_profile_picture'] = defaultProfilePic;
    if (profileImages != null) {
      data['profile_pictures'] =
          profileImages!.map((v) => v.toJson()).toList();
    } else{
      data['profile_pictures'] = [];
    }
    return data;
  }
}

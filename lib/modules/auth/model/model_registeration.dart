import 'package:cennec/modules/auth/model/model_login.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelRegistration {
  bool? success;
  String? message;
  LoginDetail? data;
  ModelError? error;


  ModelRegistration({this.success, this.message, this.data,this.error});

  ModelRegistration.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ?  ModelError.fromJson(json['error']) : null;
    data = json['data'] != null ?  LoginDetail.fromJson(json['data']) : null;
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

class Data {
  User? user;
  String? token;

  Data({this.user, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class User {
  String? username;
  String? name;
  String? email;
  int? invitationCodeId;
  String? updatedAt;
  String? createdAt;
  int? id;

  User(
      {this.username,
        this.name,
        this.email,
        this.invitationCodeId,
        this.updatedAt,
        this.createdAt,
        this.id});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    email = json['email'];
    invitationCodeId = json['invitation_code_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['name'] = name;
    data['email'] = email;
    data['invitation_code_id'] = invitationCodeId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}

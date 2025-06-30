import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelUserEditProfilePrefs {
  bool? success;
  String? message;
  ModelError? error;
  Data? data;

  ModelUserEditProfilePrefs(
      {this.success, this.message, this.error, this.data});

  ModelUserEditProfilePrefs.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ? ModelError.fromJson(json['error']) : null;
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
  int? id;
  String? username;
  String? email;
  String? userStatus;
  String? createdAt;
  String? updatedAt;
  int? userId;
  String? dob;
  String? gender;
  String? bio;
  String? isSmoke;
  String? isDrink;
  String? location;
  String? locationLatitude;
  String? locationLongitude;

  Data(
      {this.id,
        this.username,
        this.email,
        this.userStatus,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.dob,
        this.gender,
        this.bio,
        this.location,
        this.locationLatitude,
        this.locationLongitude,
        this.isSmoke,
        this.isDrink});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['name'];
    email = json['email'];
    userStatus = json['user_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    dob = json['dob'];
    gender = json['gender'];
    bio = json['bio'];
    isSmoke = json['is_smoke'];
    isDrink = json['is_drink'];
    location = json['location'];
    locationLatitude = json['location_latitude'];
    locationLongitude = json['location_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['user_status'] = userStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_id'] = userId;
    data['dob'] = dob;
    data['gender'] = gender;
    data['bio'] = bio;
    data['is_smoke'] = isSmoke;
    data['is_drink'] = isDrink;
    return data;
  }
}

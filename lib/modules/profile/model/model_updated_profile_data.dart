import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelUpdatedProfileData {
  bool? success;
  String? message;
  ModelError? error;
  Data? data;

  ModelUpdatedProfileData({this.success, this.message, this.error, this.data});

  ModelUpdatedProfileData.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  String? location;
  String? bio;
  String? dob;
  String? gender;
  String? latitude;
  String? longitude;
  int? isSmoke;
  int? isDrink;

  Data(
      {this.userId,
        this.location,
        this.bio,
        this.dob,
        this.gender,
        this.latitude,
        this.longitude,
        this.isSmoke,
        this.isDrink});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    location = json['location'];
    bio = json['bio'];
    dob = json['dob'];
    gender = json['gender'];
    isSmoke = json['is_smoke'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isDrink = json['is_drink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['location'] = location;
    data['bio'] = bio;
    data['dob'] = dob;
    data['gender'] = gender;
    data['is_smoke'] = isSmoke;
    data['is_drink'] = isDrink;
    return data;
  }
}

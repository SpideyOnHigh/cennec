import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelGetUserSettings {
  bool? success;
  String? message;
  UserSettings? data;
  ModelError? error;


  ModelGetUserSettings({this.success, this.message, this.data,this.error});

  ModelGetUserSettings.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ?  ModelError.fromJson(json['error']) : null;
    data = json['data'] != null ? UserSettings.fromJson(json['data']) : null;
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

class UserSettings {
  int? isNotificationOn;
  bool? isNotificationOnBool;
  int? isDisplayLocation;
  bool? isDisplayLocationBool;
  int? isDisplayAge;
  bool? isDisplayAgeBool;

  UserSettings({
    this.isNotificationOn,
    this.isDisplayLocation,
    this.isDisplayAge,
    this.isNotificationOnBool = false,
    this.isDisplayLocationBool = false,
    this.isDisplayAgeBool = false
  });

  UserSettings.fromJson(Map<String, dynamic> json) {//0 => false, 1 => true
    isNotificationOn = json['is_notification_on'];
    isNotificationOnBool = json['is_notification_on'] == 0 ? false : true;
    isDisplayLocation = json['is_display_location'];
    isDisplayLocationBool = json['is_display_location'] == 0 ? false : true;
    isDisplayAge = json['is_display_age'];
    isDisplayAgeBool = json['is_display_age'] == 0 ? false : true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_notification_on'] = isNotificationOn;
    data['is_display_location'] = isDisplayLocation;
    data['is_display_age'] = isDisplayAge;
    return data;
  }
}

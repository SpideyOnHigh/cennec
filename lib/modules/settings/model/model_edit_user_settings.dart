import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelEditSettingsResponse {
  bool? success;
  String? message;
  EditedUserSettings? data;
  ModelError? error;


  ModelEditSettingsResponse({this.success, this.message, this.data,this.error});

  ModelEditSettingsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ?  ModelError.fromJson(json['error']) : null;
    data = json['data'] != null ? EditedUserSettings.fromJson(json['data']) : null;
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

class EditedUserSettings {
  int? userId;
  bool? isNotificationOn;
  bool? isDisplayLocation;
  bool? isDisplayAge;

  EditedUserSettings(
      {this.userId,
        this.isNotificationOn,
        this.isDisplayLocation,
        this.isDisplayAge});

  EditedUserSettings.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    isNotificationOn = json['is_notification_on'];
    isDisplayLocation = json['is_display_location'];
    isDisplayAge = json['is_display_age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['is_notification_on'] = isNotificationOn;
    data['is_display_location'] = isDisplayLocation;
    data['is_display_age'] = isDisplayAge;
    return data;
  }
}

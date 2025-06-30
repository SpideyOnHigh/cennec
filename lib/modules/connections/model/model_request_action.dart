import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelRequestAction {
  bool? success;
  String? message;
  ModelError? error;
  Data? data;

  ModelRequestAction({this.success, this.message, this.error, this.data});

  ModelRequestAction.fromJson(Map<String, dynamic> json) {
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
  int? fromUserId;
  int? toUserId;
  String? requestStatus;

  Data({this.fromUserId, this.toUserId, this.requestStatus});

  Data.fromJson(Map<String, dynamic> json) {
    fromUserId = json['action_by'];
    toUserId = json['action_to'];
    requestStatus = json['request_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from_user_id'] = fromUserId;
    data['to_user_id'] = toUserId;
    data['request_status'] = requestStatus;
    return data;
  }
}

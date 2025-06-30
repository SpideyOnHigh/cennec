
import '../../core/api_service/error_model.dart';

class SendMessageResponse {
  SendMessageResponse({
    required this.success,
    required this.message,
    this.error,
    required this.data,
  });
  late final bool? success;
  late final String? message;
  late final ModelError? error;
  late final SentMessageData? data;
  
  SendMessageResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    error = (json['error'] != null ?  ModelError.fromJson(json['error']) : null);
    data = json['data'] != null ? SentMessageData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['success'] = success;
    result['message'] = message;
    result['error'] = error; // if error is a custom object
    result['data'] = data?.toJson();    // <-- assuming `data` is not a Map, but a model
    return result;
  }

}

class SentMessageData {
  SentMessageData({
    required this.id,
    required this.messageContent,
    required this.status,
    required this.date,
    required this.time,
    required this.isMe,
    required this.notificationType,
  });
  late final int id;
  late final String messageContent;
  late final String status;
  late final String date;
  late final String time;
  late final bool isMe;
  late final String notificationType;

  SentMessageData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    messageContent = json['message_content'];
    status = json['status'];
    date = json['date'];
    time = json['time'];
    isMe = json['is_me'];
    notificationType = json['notification_type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['message_content'] = messageContent;
    data['status'] = status;
    data['date'] = date;
    data['time'] = time;
    data['is_me'] = isMe;
    data['notification_type'] = notificationType;
    return data;
  }
}
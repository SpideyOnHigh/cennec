class ModelNotificationData {
  ModelNotificationData({
    required this.date,
    required this.isMe,
    required this.messageContent,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.time,
    required this.senderUserId,
    required this.receiverUserId,
    required this.senderUserName,
    required this.deviceToken,
    required this.status,
  });
  late final String date;
  late final String isMe;
  late final String messageContent;
  late final String updatedAt;
  late final String createdAt;
  late final String id;
  late final String time;
  late final String senderUserId;
  late final String receiverUserId;
  late final String senderUserName;
  late final String deviceToken;
  late final String status;

  ModelNotificationData.fromJson(Map<String, dynamic> json){
    date = json['date'];
    isMe = json['is_me'];
    messageContent = json['message_content'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    time = json['time'];
    senderUserId = json['sender_user_id'];
    receiverUserId = json['receiver_user_id'];
    senderUserName = json['sender_user_name'];
    deviceToken = json['deviceToken'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['date'] = date;
    data['is_me'] = isMe;
    data['message_content'] = messageContent;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['time'] = time;
    data['sender_user_id'] = senderUserId;
    data['receiver_user_id'] = receiverUserId;
    data['sender_user_name'] = senderUserName;
    data['deviceToken'] = deviceToken;
    data['status'] = status;
    return data;
  }
}
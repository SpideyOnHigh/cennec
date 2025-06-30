class MessageRoomRequestData {
  MessageRoomRequestData({
    required this.fromUserId,
    required this.page,
    required this.name,
    required this.imageUrl,
  });
  late final int fromUserId;
  late final int page;
  late final String name;
  late final String imageUrl;

  MessageRoomRequestData.fromJson(Map<String, dynamic> json){
    fromUserId = json['from_user_id'];
    page = json['page'];
    imageUrl = json['imageUrl'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['from_user_id'] = fromUserId;
    data['page'] = page;
    data['name'] = name;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelPosts {
  int? code;
  String? message;
  List<PostData>? data;
  ModelError? error;
  int? count;
  int? total;
  int? currentPage;
  int? perPage;

  ModelPosts({
    this.code,
    this.message,
    this.data,
    this.error,
    this.count,
    this.total,
    this.currentPage,
    this.perPage,
  });

  ModelPosts.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    error = json['error'] != null ? ModelError.fromJson(json['error']) : null;
    count = json['count'];
    total = json['total'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
    if (json['data'] != null) {
      data = <PostData>[];
      json['data'].forEach((v) {
        data!.add(PostData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['count'] = count;
    data['total'] = total;
    data['current_page'] = currentPage;
    data['per_page'] = perPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostData {
  int? id;
  int? userId;
  String? userName;
  String? activity;
  String? location;
  String? meetAt;
  String? meetWith;
  String? discussionTopic;
  String? description;
  String? createdAt;
  int? interestMatchCount;
  String? userImage;
  bool? isFriend;

  PostData({
    this.id,
    this.userId,
    this.userName,
    this.activity,
    this.location,
    this.meetAt,
    this.meetWith,
    this.discussionTopic,
    this.description,
    this.createdAt,
    this.interestMatchCount,
    this.userImage,
    this.isFriend,
  });

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    activity = json['activity'];
    location = json['location'];
    meetAt = json['meet_at'];
    meetWith = json['meet_with'];
    discussionTopic = json['discussion_topic'];
    description = json['description'];
    createdAt = json['created_at'];
    interestMatchCount = json['interest_match_count'];
    userImage = json['user_image'];
    isFriend = json['is_friend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['activity'] = activity;
    data['location'] = location;
    data['meet_at'] = meetAt;
    data['meet_with'] = meetWith;
    data['discussion_topic'] = discussionTopic;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['interest_match_count'] = interestMatchCount;
    data['user_image'] = userImage;
    data['is_friend'] = isFriend;
    return data;
  }
}
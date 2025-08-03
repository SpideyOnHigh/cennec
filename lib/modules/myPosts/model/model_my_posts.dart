import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelMyPosts {
  int? code;
  String? message;
  List<MyPostData>? data;
  ModelError? error;
  int? count;
  int? total;
  int? currentPage;
  int? perPage;

  ModelMyPosts({
    this.code,
    this.message,
    this.data,
    this.error,
    this.count,
    this.total,
    this.currentPage,
    this.perPage,
  });

  ModelMyPosts.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    error = json['error'] != null ? ModelError.fromJson(json['error']) : null;
    count = json['count'];
    total = json['total'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
    if (json['data'] != null) {
      data = <MyPostData>[];
      json['data'].forEach((v) {
        data!.add(MyPostData.fromJson(v));
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

class MyPostData {
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
  List<UserInterest>? userInterest;
  String? userImage;
  bool? isFriend;

  MyPostData({
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
    this.userInterest,
    this.userImage,
    this.isFriend,
  });

  MyPostData.fromJson(Map<String, dynamic> json) {
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
    if (json['user_interest'] != null) {
      userInterest = <UserInterest>[];
      json['user_interest'].forEach((v) {
        userInterest!.add(UserInterest.fromJson(v));
      });
    }
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
    if (userInterest != null) {
      data['user_interest'] = userInterest!.map((v) => v.toJson()).toList();
    }
    data['user_image'] = userImage;
    data['is_friend'] = isFriend;
    return data;
  }
}

class UserInterest {
  String? interestName;
  bool? interestMatch;

  UserInterest({
    this.interestName,
    this.interestMatch,
  });

  UserInterest.fromJson(Map<String, dynamic> json) {
    interestName = json['interest_name'];
    interestMatch = json['interest_match'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['interest_name'] = interestName;
    data['interest_match'] = interestMatch;
    return data;
  }
}
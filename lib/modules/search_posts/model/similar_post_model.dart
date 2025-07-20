import '../../core/api_service/error_model.dart';
import '../../core/utils/parsing_helper.dart';

class ModelSimilarPosts {
  int? code;
  String? message;
  List<SimilarPostData>? data;
  int? count;
  int? total;
  int? currentPage;
  int? perPage;
  ModelError? error;

  ModelSimilarPosts({
    this.code,
    this.message,
    this.data,
    this.count,
    this.total,
    this.currentPage,
    this.perPage,
    this.error
  });

  ModelSimilarPosts.fromJson(Map<String, dynamic> json) {
    code = ParsingHelper.parseIntNullableMethod(json['code']);
    message = ParsingHelper.parseStringNullableMethod(json['message']);
    error = json['error'] != null ?  ModelError.fromJson(json['error']) : null;
    if (json['data'] != null) {
      data = <SimilarPostData>[];
      json['data'].forEach((v) {
        data!.add(SimilarPostData.fromJson(v));
      });
    }
    count = ParsingHelper.parseIntNullableMethod(json['count']);
    total = ParsingHelper.parseIntNullableMethod(json['total']);
    currentPage = ParsingHelper.parseIntNullableMethod(json['current_page']);
    perPage = ParsingHelper.parseIntNullableMethod(json['per_page']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['error'] = error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['total'] = this.total;
    data['current_page'] = this.currentPage;
    data['per_page'] = this.perPage;
    return data;
  }
}

class SimilarPostData {
  int? id;
  String? activity;
  String? location;
  String? meetAt;
  String? meetWith;
  String? discussionTopic;
  String? description;
  int? userId;
  String? userName;
  int? mutualConnection;
  bool? isFriend;
  int? matchPercentage;
  String? userImage;
  List<UserInterest>? userInterest;
  UserInfo? userInfo;

  SimilarPostData({
    this.id,
    this.activity,
    this.location,
    this.meetAt,
    this.meetWith,
    this.discussionTopic,
    this.description,
    this.userId,
    this.userName,
    this.mutualConnection,
    this.isFriend,
    this.matchPercentage,
    this.userImage,
    this.userInterest,
    this.userInfo
  });

  SimilarPostData.fromJson(Map<String, dynamic> json) {
    id = ParsingHelper.parseIntNullableMethod(json['id']);
    activity = ParsingHelper.parseStringNullableMethod(json['activity']);
    location = ParsingHelper.parseStringNullableMethod(json['location']);
    meetAt = ParsingHelper.parseStringNullableMethod(json['meet_at']);
    meetWith = ParsingHelper.parseStringNullableMethod(json['meet_with']);
    discussionTopic = ParsingHelper.parseStringNullableMethod(json['discussion_topic']);
    description = ParsingHelper.parseStringNullableMethod(json['description']);
    userId = ParsingHelper.parseIntNullableMethod(json['user_id']);
    userName = ParsingHelper.parseStringNullableMethod(json['user_name']);
    mutualConnection = ParsingHelper.parseIntNullableMethod(json['mutual_connection']);
    isFriend = ParsingHelper.parseBoolNullableMethod(json['is_friend']);
    matchPercentage = ParsingHelper.parseIntNullableMethod(json['match_percentage']);
    userImage = ParsingHelper.parseStringNullableMethod(json['user_image']);
    if (json['user_interest'] != null) {
      userInterest = <UserInterest>[];
      json['user_interest'].forEach((v) {
        userInterest!.add(UserInterest.fromJson(v));
      });
    }
    userInfo = json['user_info'] != null
        ? UserInfo.fromJson(json['user_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['activity'] = this.activity;
    data['location'] = this.location;
    data['meet_at'] = this.meetAt;
    data['meet_with'] = this.meetWith;
    data['discussion_topic'] = this.discussionTopic;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['mutual_connection'] = this.mutualConnection;
    data['is_friend'] = this.isFriend;
    data['match_percentage'] = this.matchPercentage;
    data['user_image'] = this.userImage;
    if (this.userInterest != null) {
      data['user_interest'] = this.userInterest!.map((v) => v.toJson()).toList();
    }
    if (this.userInfo != null) {
      data['user_info'] = this.userInfo!.toJson();
    }
    return data;
  }
}

class UserInterest {
  String? interestName;
  bool? interestMatch;

  UserInterest({this.interestName, this.interestMatch});

  UserInterest.fromJson(Map<String, dynamic> json) {
    interestName = ParsingHelper.parseStringNullableMethod(json['interest_name']);
    interestMatch = ParsingHelper.parseBoolNullableMethod(json['interest_match']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['interest_name'] = this.interestName;
    data['interest_match'] = this.interestMatch;
    return data;
  }
}

class UserInfo {
  String? bio;
  String? defaultProfilePicture;
  List<ProfilePictures>? profilePictures;
  List<LatestPosts>? latestPosts;

  UserInfo({
    this.bio,
    this.defaultProfilePicture,
    this.profilePictures,
    this.latestPosts
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    bio = ParsingHelper.parseStringNullableMethod(json['bio']);
    defaultProfilePicture = ParsingHelper.parseStringNullableMethod(json['default_profile_picture']);
    if (json['profile_pictures'] != null) {
      profilePictures = <ProfilePictures>[];
      json['profile_pictures'].forEach((v) {
        profilePictures!.add(ProfilePictures.fromJson(v));
      });
    }
    if (json['latest_posts'] != null) {
      latestPosts = <LatestPosts>[];
      json['latest_posts'].forEach((v) {
        latestPosts!.add(LatestPosts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bio'] = this.bio;
    data['default_profile_picture'] = this.defaultProfilePicture;
    if (this.profilePictures != null) {
      data['profile_pictures'] = this.profilePictures!.map((v) => v.toJson()).toList();
    }
    if (this.latestPosts != null) {
      data['latest_posts'] = this.latestPosts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfilePictures {
  int? imageId;
  String? imageUrl;
  bool? isDefault;

  ProfilePictures({this.imageId, this.imageUrl, this.isDefault});

  ProfilePictures.fromJson(Map<String, dynamic> json) {
    imageId = ParsingHelper.parseIntNullableMethod(json['image_id']);
    imageUrl = ParsingHelper.parseStringNullableMethod(json['image_url']);
    isDefault = ParsingHelper.parseBoolNullableMethod(json['is_default']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_id'] = this.imageId;
    data['image_url'] = this.imageUrl;
    data['is_default'] = this.isDefault;
    return data;
  }
}

class LatestPosts {
  int? id;
  int? userId;
  String? activity;
  String? location;
  String? meetAt;
  String? meetWith;
  String? discussionTopic;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  LatestPosts({
    this.id,
    this.userId,
    this.activity,
    this.location,
    this.meetAt,
    this.meetWith,
    this.discussionTopic,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt
  });

  LatestPosts.fromJson(Map<String, dynamic> json) {
    id = ParsingHelper.parseIntNullableMethod(json['id']);
    userId = ParsingHelper.parseIntNullableMethod(json['user_id']);
    activity = ParsingHelper.parseStringNullableMethod(json['activity']);
    location = ParsingHelper.parseStringNullableMethod(json['location']);
    meetAt = ParsingHelper.parseStringNullableMethod(json['meet_at']);
    meetWith = ParsingHelper.parseStringNullableMethod(json['meet_with']);
    discussionTopic = ParsingHelper.parseStringNullableMethod(json['discussion_topic']);
    description = ParsingHelper.parseStringNullableMethod(json['description']);
    createdAt = ParsingHelper.parseStringNullableMethod(json['created_at']);
    updatedAt = ParsingHelper.parseStringNullableMethod(json['updated_at']);
    deletedAt = ParsingHelper.parseStringNullableMethod(json['deleted_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['activity'] = this.activity;
    data['location'] = this.location;
    data['meet_at'] = this.meetAt;
    data['meet_with'] = this.meetWith;
    data['discussion_topic'] = this.discussionTopic;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
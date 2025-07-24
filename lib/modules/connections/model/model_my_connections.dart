import 'package:cennec/modules/connections/model/model_recommendations.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelMyConnections {
  bool? success;
  String? message;
  ModelError? error;
  List<ConnectionsModel>? data;
  Pagination? pagination;

  ModelMyConnections({this.success, this.message, this.error, this.data, this.pagination});

  ModelMyConnections.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ? ModelError.fromJson(json['error']) : null;
    if (json['data'] != null) {
      data = <ConnectionsModel>[];
      json['data'].forEach((v) {
        data!.add(ConnectionsModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (error != null) {
      data['error'] = error!.toJson();
    }

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class ConnectionsModel {
  int? id;
  String? name;
  String? email;
  String? defaultProfilePic;
  UserInfo? userInfo;
  List<UserInterest>? userInterest;
  bool? isFavourite;
  List<ProfileImages>? profileImages;

  ConnectionsModel({
    this.id,
    this.name,
    this.email,
    this.defaultProfilePic,
    this.userInfo,
    this.userInterest,
    this.isFavourite,
    this.profileImages,
  });

  ConnectionsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    defaultProfilePic = json['default_profile_picture'];
    userInfo = json['user_info'] != null ? UserInfo.fromJson(json['user_info']) : null;
    isFavourite = json['is_favourite'];
    if (json['user_interest'] != null) {
      userInterest = <UserInterest>[];
      json['user_interest'].forEach((v) {
        userInterest!.add(UserInterest.fromJson(v));
      });
    }
    if (json['profile_images'] != null) {
      profileImages = <ProfileImages>[];
      json['profile_images'].forEach((v) {
        profileImages!.add(ProfileImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['default_profile_picture'] = defaultProfilePic;
    if (userInfo != null) {
      data['user_info'] = userInfo!.toJson();
    }
    data['is_favourite'] = isFavourite;
    if (userInterest != null) {
      data['user_interest'] = userInterest!.map((v) => v.toJson()).toList();
    }
    if (profileImages != null) {
      data['profile_images'] = profileImages!.map((v) => v.toJson()).toList();
    }
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
    this.latestPosts,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    bio = json['bio'];
    defaultProfilePicture = json['default_profile_picture'];
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
    data['bio'] = bio;
    data['default_profile_picture'] = defaultProfilePicture;
    if (profilePictures != null) {
      data['profile_pictures'] = profilePictures!.map((v) => v.toJson()).toList();
    }
    if (latestPosts != null) {
      data['latest_posts'] = latestPosts!.map((v) => v.toJson()).toList();
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
    imageId = json['image_id'];
    imageUrl = json['image_url'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_id'] = imageId;
    data['image_url'] = imageUrl;
    data['is_default'] = isDefault;
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
    this.deletedAt,
  });

  LatestPosts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    activity = json['activity'];
    location = json['location'];
    meetAt = json['meet_at'];
    meetWith = json['meet_with'];
    discussionTopic = json['discussion_topic'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['activity'] = activity;
    data['location'] = location;
    data['meet_at'] = meetAt;
    data['meet_with'] = meetWith;
    data['discussion_topic'] = discussionTopic;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class UserInterest {
  String? interestName;
  bool? interestMatch;

  UserInterest({this.interestName, this.interestMatch});

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

class ProfileImages {
  int? imageId;
  String? imageUrl;
  bool? isDefault;

  ProfileImages({this.imageId, this.imageUrl, this.isDefault});

  ProfileImages.fromJson(Map<String, dynamic> json) {
    imageId = json['image_id'];
    imageUrl = json['image_url'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_id'] = imageId;
    data['image_url'] = imageUrl;
    data['is_default'] = isDefault;
    return data;
  }
}

class Pagination {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  String? nextPageUrl;
  String? prevPageUrl;

  Pagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    nextPageUrl = json['next_page_url'];
    prevPageUrl = json['prev_page_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['per_page'] = perPage;
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['next_page_url'] = nextPageUrl;
    data['prev_page_url'] = prevPageUrl;
    return data;
  }
}
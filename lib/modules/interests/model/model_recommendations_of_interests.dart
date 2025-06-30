import 'package:cennec/modules/connections/model/model_recommendations.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelRecommendationsOfInterest {
  bool? success;
  String? message;
  ModelError? error;
  bool? interestExists = false;
  List<RecommendationsList>? data;
  List<RelatedInterest>? relatedInterest;
  Pagination? pagination;


  ModelRecommendationsOfInterest(
      {this.success, this.message, this.error, this.interestExists = false, this.data,this.relatedInterest,this.pagination});

  ModelRecommendationsOfInterest.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ?  ModelError.fromJson(json['error']) : null;
    interestExists = json['interest_exists'];
    if (json['data'] != null) {
      data = <RecommendationsList>[];
      json['data'].forEach((v) {
        data!.add(RecommendationsList.fromJson(v));
      });

    }
    if (json['related_interest'] != null) {
      relatedInterest = <RelatedInterest>[];
      json['related_interest'].forEach((v) {
        relatedInterest!.add(RelatedInterest.fromJson(v));
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
    data['error'] = error;
    data['interest_exists'] = interestExists;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (relatedInterest != null) {
      data['related_interest'] =
          relatedInterest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



class RecommendationsList {
  String? name;
  String? username;
  String? email;
  int? userId;
  String? dob;
  String? gender;
  String? bio;
  int? mutualInterests;
  bool? isFavourite;
  bool? isConnected;
  String? defaultProfilePic;
  List<ProfileImages>? profileImages;


  RecommendationsList(
      {this.name,
        this.username,
        this.email,
        this.userId,
        this.dob,
        this.gender,
        this.bio,
        this.mutualInterests,
        this.isFavourite = false,
        this.isConnected = false,
        this.profileImages,
        this.defaultProfilePic});

  RecommendationsList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    email = json['email'];
    userId = json['user_id'];
    dob = json['dob'];
    gender = json['gender'];
    bio = json['bio'];
    isFavourite = json['is_favourite'];
    isConnected = json['is_connected'];
    mutualInterests = json['mutual_interests'];
    defaultProfilePic = json['default_profile_picture'];
    if (json['profile_images'] != null) {
      profileImages = <ProfileImages>[];
      json['profile_images'].forEach((v) {
        profileImages!.add(ProfileImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['user_id'] = userId;
    data['dob'] = dob;
    data['gender'] = gender;
    data['bio'] = bio;
    data['mutual_interests'] = mutualInterests;
    data['is_favourite'] = isFavourite;
    data['is_connected'] = isConnected;
    data['default_profile_picture'] = defaultProfilePic;
    return data;
  }
}

class RelatedInterest {
  int? id;
  String? interestName;
  String? interestColor;
  bool? isInterestedAdded;

  RelatedInterest(
      {this.id, this.interestName, this.interestColor, this.isInterestedAdded});

  RelatedInterest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    interestName = json['interest_name'];
    interestColor = json['interest_color'];
    isInterestedAdded = json['is_interested_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['interest_name'] = interestName;
    data['interest_color'] = interestColor;
    data['is_interested_added'] = isInterestedAdded;
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

  Pagination(
      {this.total,
        this.perPage,
        this.currentPage,
        this.lastPage,
        this.nextPageUrl,
        this.prevPageUrl});

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



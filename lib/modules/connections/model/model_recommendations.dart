import 'package:cennec/modules/core/api_service/error_model.dart';


class ModelRecommendations {
  bool? success;
  String? message;
  ModelError? error;
  List<RecommendationData>? data;
  Pagination? pagination;


  ModelRecommendations({this.success, this.message, this.error, this.data});

  ModelRecommendations.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ?  ModelError.fromJson(json['error']) : null;
    if (json['data'] != null) {
      data = <RecommendationData>[];
      json['data'].forEach((v) {
        data!.add(RecommendationData.fromJson(v));
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecommendationData {
  String? name;
  String? username;
  String? email;
  int? userId;
  String? dob;
  String? gender;
  String? bio;
  bool? isFavourite;
  bool? isConnected;
  List<ProfileImages>? profileImages;
  List<UserQueAns>? userQueAns;
  List<UserInterests>? userInterests;
  String? defaultProfilePic;


  RecommendationData(
      {this.name,
        this.username,
        this.email,
        this.userId,
        this.dob,
        this.gender,
        this.bio,
        this.isFavourite,
        this.isConnected,
        this.profileImages,
        this.userQueAns,
        this.userInterests,
        this.defaultProfilePic
      });

  RecommendationData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    email = json['email'];
    userId = json['user_id'];
    dob = json['dob'];
    gender = json['gender'];
    bio = json['bio'];
    isFavourite = json['is_favourite'];
    isConnected = json['is_connected'];
    if (json['profile_images'] != null) {
      profileImages = <ProfileImages>[];
      json['profile_images'].forEach((v) {
        profileImages!.add(ProfileImages.fromJson(v));
      });
    }
    if (json['user_que_ans'] != null) {
      userQueAns = <UserQueAns>[];
      json['user_que_ans'].forEach((v) {
        userQueAns!.add(UserQueAns.fromJson(v));
      });
    }
    if (json['user_interests'] != null) {
      userInterests = <UserInterests>[];
      json['user_interests'].forEach((v) {
        userInterests!.add(UserInterests.fromJson(v));
      });
    }
    defaultProfilePic = json['default_profile_picture'];
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
    data['is_favourite'] = isFavourite;
    data['is_connected'] = isConnected;
    if (userQueAns != null) {
      data['user_que_ans'] = userQueAns!.map((v) => v.toJson()).toList();
    }
    if (userInterests != null) {
      data['user_interests'] =
          userInterests!.map((v) => v.toJson()).toList();
    }
    data['default_profile_picture'] = defaultProfilePic;
    return data;
  }
}

class ProfileImages {
  int? imageId;
  String? imageUrl;
  bool? isDefault;

  ProfileImages({this.imageId, this.imageUrl,this.isDefault});

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

class UserQueAns {
  int? questionId;
  String? question;
  String? answer;

  UserQueAns({this.questionId, this.question, this.answer});

  UserQueAns.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}

class UserInterests {
  int? interestId;
  String? interestName;
  String? interestColor;

  UserInterests({this.interestId, this.interestName, this.interestColor});

  UserInterests.fromJson(Map<String, dynamic> json) {
    interestId = json['interest_id'];
    interestName = json['interest_name'];
    interestColor = json['interest_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['interest_id'] = interestId;
    data['interest_name'] = interestName;
    data['interest_color'] = interestColor;
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



import 'package:cennec/modules/connections/model/model_recommendations.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelFetchUserDetail {
  bool? success;
  String? message;
  ModelError? error;
  Data? data;

  ModelFetchUserDetail({this.success, this.message, this.error, this.data});

  ModelFetchUserDetail.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? username;
  String? email;
  int? invitationCodeId;
  String? createdAt;
  String? updatedAt;
  String? dob;
  String? gender;
  String? bio;
  String? isSmoke;
  String? isDrink;
  int? distancePreference;
  int? isAgePreference;
  int? fromAgePreference;
  int? toAgePreference;
  int? isMutualInterestPreference;
  String? genderPreference;
  int? requestStatus;
  bool? isFavourite;
  bool? isConnected;
  bool? isSentRequest;
  bool? isGotRequest;
  String? defaultProfilePic;
  String? requestComment;
  // List<String>? profilePictures;
  List<MutualInterests>? mutualInterests;
  List<QuestionsWithAnswers>? questionAnswersList;
  List<ProfileImages>? profileImages;


  Data(
      {this.id,
        this.username,
        this.email,
        this.invitationCodeId,
        this.createdAt,
        this.updatedAt,
        this.dob,
        this.gender,
        this.bio,
        this.isSmoke,
        this.isDrink,
        this.distancePreference,
        this.isAgePreference,
        this.fromAgePreference,
        this.toAgePreference,
        this.isFavourite,
        this.isConnected,
        this.isMutualInterestPreference,
        this.genderPreference,
        this.defaultProfilePic,
        // this.profilePictures,
        this.requestStatus,
        this.profileImages,
        this.isSentRequest,

        this.questionAnswersList,
        this.isGotRequest,
        this.requestComment,
        this.mutualInterests});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    invitationCodeId = json['invitation_code_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    dob = json['dob'];
    gender = json['gender'];
    bio = json['bio'];
    isSmoke = json['is_smoke'];
    isDrink = json['is_drink'];
    distancePreference = json['distance_preference'];
    isAgePreference = json['is_age_preference'];
    fromAgePreference = json['from_age_preference'];
    toAgePreference = json['to_age_preference'];
    isMutualInterestPreference = json['is_mutual_interest_preference'];
    genderPreference = json['gender_preference'];
    isFavourite = json['is_favourite'];
    isConnected = json['is_connected'];
    requestStatus = json['request_status'];
    isSentRequest = json['is_sent_request'];
    // profilePictures =  json['profile_pictures'].cast<String>();
    if (json['mutual_interests'] != null) {
      mutualInterests = <MutualInterests>[];
      json['mutual_interests'].forEach((v) {
        mutualInterests!.add(MutualInterests.fromJson(v));
      });
    }
    if (json['questions_with_answers'] != null) {
      questionAnswersList = <QuestionsWithAnswers>[];
      json['questions_with_answers'].forEach((v) {
        questionAnswersList!.add( QuestionsWithAnswers.fromJson(v));
      });
    }
    if (json['profile_pictures'] != null) {
      profileImages = <ProfileImages>[];
      json['profile_pictures'].forEach((v) {
        profileImages!.add(ProfileImages.fromJson(v));
      });
    }
    defaultProfilePic = json['default_profile_picture'];
    isGotRequest = json['is_got_request'];
    requestComment = json['user_comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['invitation_code_id'] = invitationCodeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['dob'] = dob;
    data['gender'] = gender;
    data['bio'] = bio;
    data['is_smoke'] = isSmoke;
    data['is_drink'] = isDrink;
    data['distance_preference'] = distancePreference;
    data['is_age_preference'] = isAgePreference;
    data['from_age_preference'] = fromAgePreference;
    data['to_age_preference'] = toAgePreference;
    data['request_status'] = requestStatus;
    data['is_mutual_interest_preference'] = isMutualInterestPreference;
    data['gender_preference'] = genderPreference;
    data['default_profile_picture'] = defaultProfilePic;
    data['is_sent_request'] = isSentRequest;
    data['is_got_request'] = isSentRequest;
    data['user_comment'] = requestComment;
    if (profileImages != null) {
      data['profile_pictures'] =
          profileImages!.map((v) => v.toJson()).toList();
    }
    if (mutualInterests != null) {
      data['mutual_interests'] =
          mutualInterests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MutualInterests {
  int? id;
  String? interestName;
  String? interestColor;

  MutualInterests({this.id, this.interestName, this.interestColor});

  MutualInterests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    interestName = json['interest_name'];
    interestColor = json['interest_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['interest_name'] = interestName;
    data['interest_color'] = interestColor;
    return data;
  }
}

class QuestionsWithAnswers {
  int? questionId;
  String? question;
  String? answer;

  QuestionsWithAnswers({this.questionId, this.question, this.answer});

  QuestionsWithAnswers.fromJson(Map<String, dynamic> json) {
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

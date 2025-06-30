import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelFeedbackQuestions {
  bool? success;
  String? message;
  int? givenRating;
  ModelError? error;
  List<Data>? data;

  ModelFeedbackQuestions({this.success, this.message,this.givenRating ,this.error, this.data});

  ModelFeedbackQuestions.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    givenRating = json['givenRating'];
    error = json['error'] != null ? ModelError.fromJson(json['error']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
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

class Data {
  int? id;
  String? feedbackTitle;
  String? feedbackStatus;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Data(
      {this.id,
        this.feedbackTitle,
        this.feedbackStatus,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedbackTitle = json['feedback_title'];
    feedbackStatus = json['feedback_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['feedback_title'] = feedbackTitle;
    data['feedback_status'] = feedbackStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

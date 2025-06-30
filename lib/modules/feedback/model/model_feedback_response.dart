import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelFeedbackResponse {
  bool? success;
  String? message;
  ModelError? error;
  Data? data;

  ModelFeedbackResponse({this.success, this.message, this.error, this.data});

  ModelFeedbackResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ? ModelError.fromJson(json['error']) : null;
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
  int? userId;
  int? rating;
  int? feedbackTypeId;
  String? comment;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.userId,
        this.rating,
        this.feedbackTypeId,
        this.comment,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    rating = json['rating'];
    feedbackTypeId = json['feedback_type_id'];
    comment = json['comment'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['rating'] = rating;
    data['feedback_type_id'] = feedbackTypeId;
    data['comment'] = comment;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}

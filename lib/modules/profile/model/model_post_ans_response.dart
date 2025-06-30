import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelQueAnsPostResponse {
  bool? success;
  String? message;
  ModelError? error;
  Data? data;

  ModelQueAnsPostResponse({this.success, this.message, this.error, this.data});

  ModelQueAnsPostResponse.fromJson(Map<String, dynamic> json) {
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
  int? questionId;
  String? answer;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.userId,
        this.questionId,
        this.answer,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    questionId = json['question_id'];
    answer = json['answer'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['question_id'] = questionId;
    data['answer'] = answer;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}

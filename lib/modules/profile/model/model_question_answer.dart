import 'package:cennec/modules/connections/model/model_fetch_user_detail.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelQuestionAnswers {
  bool? success;
  String? message;
  ModelError? error;
  List<QuestionsWithAnswers>? data;

  ModelQuestionAnswers({this.success, this.message, this.error, this.data});

  ModelQuestionAnswers.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ? ModelError.fromJson(json['error']) : null;
    if (json['data'] != null) {
      data = <QuestionsWithAnswers>[];
      json['data'].forEach((v) {
        data!.add(QuestionsWithAnswers.fromJson(v));
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


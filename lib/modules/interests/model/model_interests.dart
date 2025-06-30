import 'dart:ui';

import 'package:cennec/modules/core/api_service/error_model.dart';

class Interest {
  final String name;
  bool isSelected;
  Color? color;

  Interest({required this.name, this.isSelected = false, this.color});
}

class ModelInterestsList {
  bool? success;
  String? message;
  ModelError? error;
  int? notificationCount;
  List<ModelInterests>? data;

  ModelInterestsList({this.success, this.message, this.data, this.error,this.notificationCount});

  ModelInterestsList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    notificationCount = json['notification_count'];
    error = json['error'] != null ? ModelError.fromJson(json['error']) : null;
    if (json['data'] != null) {
      data = <ModelInterests>[];
      json['data'].forEach((v) {
        data!.add(ModelInterests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['notification_count'] = notificationCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModelInterests {
  int? id;
  String? interestName;
  String? interestColor;
  String? createdAt;
  String? updatedAt;
  bool? isSelected = false;
  bool? isInterestAdded;
  String? deletedAt;

  ModelInterests({this.id, this.interestName,this.isInterestAdded ,this.isSelected = false, this.interestColor, this.createdAt, this.updatedAt, this.deletedAt});

  ModelInterests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    interestName = json['interest_name'];
    interestColor = json['interest_color'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    isInterestAdded = json['is_interested_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['interest_name'] = interestName;
    data['interest_color'] = interestColor;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['is_interested_added'] = isInterestAdded;
    return data;
  }
}

class ModelInterestsDataTransfer {
   int? interestId;
   String? interestName;
  ModelInterestsDataTransfer({this.interestId, this.interestName});
}


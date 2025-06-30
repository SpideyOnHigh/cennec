import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelGetImages {
  bool? success;
  String? message;
  ModelError? error;
  List<Data>? data;

  ModelGetImages({this.success, this.message, this.error, this.data});

  ModelGetImages.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ?  ModelError.fromJson(json['error']) : null;
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
  String? imagePath;
  bool? isDefault;

  Data({this.id, this.imagePath,this.isDefault});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagePath = json['image_path'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image_path'] = imagePath;
    data['is_default'] = isDefault;
    return data;
  }
}

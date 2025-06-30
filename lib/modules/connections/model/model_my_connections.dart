import 'package:cennec/modules/connections/model/model_recommendations.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelMyConnections {
  bool? success;
  String? message;
  ModelError? error;
  List<ConnectionsModel>? data;
  Pagination? pagination;


  ModelMyConnections({this.success, this.message, this.error, this.data,this.pagination});

  ModelMyConnections.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'] != null ?  ModelError.fromJson(json['error']) : null;
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
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConnectionsModel {
  int? id;
  String? name;
  String? email;
  String? defaultProfilePic;
  List<ProfileImages>? profileImages;

  ConnectionsModel({this.id, this.name, this.email, this.profileImages,this.defaultProfilePic});

  ConnectionsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
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
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['default_profile_picture'] = defaultProfilePic;
    // if (profileImages != null) {
    //   data['profile_images'] =
    //       profileImages!.map((v) => v.toJson()).toList();
    // }
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

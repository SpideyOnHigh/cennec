import 'model_my_connections.dart';

class FavouritesModel {
  int? id;
  String? name;
  String? email;
  String? defaultProfilePic;
  bool? isConnected;
  UserInfo? userInfo;
  List<UserInterest>? userInterest;
  bool? isFavourite;
  List<ProfileImages>? profileImages;

  FavouritesModel({
    this.id,
    this.name,
    this.email,
    this.defaultProfilePic,
    this.isConnected,
    this.userInfo,
    this.userInterest,
    this.isFavourite,
    this.profileImages,
  });

  FavouritesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    defaultProfilePic = json['default_profile_picture'];
    isConnected = json['is_connected'];
    isFavourite = json['is_favourite'];
    userInfo = json['user_info'] != null ? UserInfo.fromJson(json['user_info']) : null;

    if (json['user_interest'] != null) {
      userInterest = <UserInterest>[];
      json['user_interest'].forEach((v) {
        userInterest!.add(UserInterest.fromJson(v));
      });
    }

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
    data['is_connected'] = isConnected;
    data['is_favourite'] = isFavourite;

    if (userInfo != null) {
      data['user_info'] = userInfo!.toJson();
    }

    if (userInterest != null) {
      data['user_interest'] = userInterest!.map((v) => v.toJson()).toList();
    }

    if (profileImages != null) {
      data['profile_images'] = profileImages!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
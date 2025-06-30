import 'package:cennec/modules/core/api_service/error_model.dart';

class ModelPreferences {
  bool? success;
  String? message;
  ModelError? error;
  Data? data;

  ModelPreferences({this.success, this.message, this.error, this.data});

  ModelPreferences.fromJson(Map<String, dynamic> json) {
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
  String? location;
  double? locationLatitude;
  double? locationLongitude;
  bool? isDistancePreference;
  num? distancePreference;
  String? dob;
  bool? isAgePreference;
  int? fromAgePreference;
  int? toAgePreference;
  bool? isMutualInterestPreference;
  num? minMutualInterest;
  String? genderPreference;
  bool? isDisplayInSearch;
  bool? isDisplayInRecommendation;
  int? age;
  num? maxDistancePref;
  num? minAgePreference;
  num? maxAgePreference;
  num? maxMutualInterestPref;

  Data(
      {this.location,
        this.locationLatitude,
        this.locationLongitude,
        this.isDistancePreference,
        this.distancePreference,
        this.dob,
        this.isAgePreference,
        this.fromAgePreference,
        this.toAgePreference,
        this.isMutualInterestPreference,
        this.minMutualInterest,
        this.genderPreference,
        this.isDisplayInSearch,
        this.isDisplayInRecommendation,
        this.age,
        this.maxDistancePref,
        this.minAgePreference,
        this.maxAgePreference,
        this.maxMutualInterestPref});

  Data.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    locationLatitude = json['location_latitude'];
    locationLongitude = json['location_longitude'];
    isDistancePreference = json['is_distance_preference'];
    distancePreference = json['distance_preference'];
    dob = json['dob'];
    isAgePreference = json['is_age_preference'];
    fromAgePreference = json['from_age_preference'];
    toAgePreference = json['to_age_preference'];
    isMutualInterestPreference = json['is_mutual_interest_preference'];
    minMutualInterest = json['min_mutual_interest'];
    genderPreference = json['gender_preference'];
    isDisplayInSearch = json['is_display_in_search'];
    isDisplayInRecommendation = json['is_display_in_recommendation'];
    age = json['age'];
    maxDistancePref = json['max_distance_pref'];
    minAgePreference = json['min_age_preference'];
    maxAgePreference = json['max_age_preference'];
    maxMutualInterestPref = json['max_mutual_interest_pref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location'] = location;
    data['location_latitude'] = locationLatitude;
    data['location_longitude'] = locationLongitude;
    data['is_distance_preference'] = isDistancePreference;
    data['distance_preference'] = distancePreference;
    data['dob'] = dob;
    data['is_age_preference'] = isAgePreference;
    data['from_age_preference'] = fromAgePreference;
    data['to_age_preference'] = toAgePreference;
    data['is_mutual_interest_preference'] = isMutualInterestPreference;
    data['min_mutual_interest'] = minMutualInterest;
    data['gender_preference'] = genderPreference;
    data['is_display_in_search'] = isDisplayInSearch;
    data['is_display_in_recommendation'] = isDisplayInRecommendation;
    data['age'] = age;
    data['max_distance_pref'] = maxDistancePref;
    data['min_age_preference'] = minAgePreference;
    data['max_age_preference'] = maxAgePreference;
    data['max_mutual_interest_pref'] = maxMutualInterestPref;
    return data;
  }
}

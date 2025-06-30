/// A [ModelCommonAuthorised] widget is a widget that describes part of the API Model Unauthorised
/// A dart class that is used to parse the json response from the server.
class ModelCommonAuthorised {
  String? message;
  bool? status;

  ModelCommonAuthorised({this.message, this.status});

  ModelCommonAuthorised.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

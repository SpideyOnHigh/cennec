import '../../core/api_service/error_model.dart';

class ImageUploadResponse {
  ImageUploadResponse({
    required this.success,
     this.error,
    required this.message,
     this.data,
  });
  late final bool success;
  late final ModelError? error;
  late final String message;
  late final void data;

  ImageUploadResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    error = (json['error'] != null ?  ModelError.fromJson(json['error']) : null);
    message = json['message'];
    data = null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    data['data'] = data;
    return data;
  }
}
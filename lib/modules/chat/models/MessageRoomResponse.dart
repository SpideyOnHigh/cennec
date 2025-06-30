import 'package:intl/intl.dart';

import '../../core/api_service/error_model.dart';

class MessageRoomResponse {
  MessageRoomResponse({
    required this.success,
    required this.message,
    this.error,
    required this.data,
    required this.pagination,
    required this.isReported,
  });
  late final bool success;
  late final String message;
  late final ModelError? error;
  late final List<MessageModel> data;
  late final Pagination pagination;
  late final bool isReported;
  late final bool reportedByMe;

  MessageRoomResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    isReported = json['user_reported'];
    reportedByMe = json['reported_by_me'];
    error = (json['error'] != null ?  ModelError.fromJson(json['error']) : null);
    data = List.from(json['data']).map((e)=>MessageModel.fromJson(e)).toList();
    pagination = Pagination.fromJson(json['pagination']);
  }
  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    result['success'] = success;
    result['message'] = message;
    result['error'] = error;
    result['user_reported'] = isReported;
    result['reported_by_me'] = reportedByMe;
    result['data'] = data.map((e) => e.toJson()).toList();
    result['pagination'] = pagination.toJson();
    return result;
  }

}

class MessageModel {
  MessageModel({
    required this.id,
    required this.messageContent,
    required this.status,
    required this.date,
    required this.time,
    required this.isMe,
  });
  late final int id;
  late final String messageContent;
  late final String status;
  late final String date;
  late final String time;
  late final bool isMe;
  bool confirm = true;

  MessageModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    messageContent = json['message_content'];
    status = json['status'];
    date = json['date'];
    time = json['time'];
    isMe = json['is_me'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['message_content'] = messageContent;
    data['status'] = status;
    data['date'] = date;
    data['time'] = time;
    data['is_me'] = isMe;
    return data;
  }

  String get getTimeToLocal {
    DateTime? utcTime = DateFormat('yyyy-MM-dd hh:mm a').tryParse("$date $time", true);
    if (utcTime != null) {
      DateTime localTime = utcTime.toLocal();
      return DateFormat('yyyy-MM-dd hh:mm a').format(localTime);
    }
    return "$date $time";
  }
}

class Pagination {
  Pagination({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.nextPageUrl,
    this.prevPageUrl,
  });
  late final int? total;
  late final int? perPage;
  late final int? currentPage;
  late final int? lastPage;
  late final String? nextPageUrl;
  late final String? prevPageUrl;

  Pagination.fromJson(Map<String, dynamic> json){
    total = json['total'] ?? 0;
    perPage = json['per_page'] ?? 0;
    currentPage = json['current_page'] ?? 0;
    lastPage = json['last_page'] ?? 0;
    nextPageUrl = json['next_page_url'] ?? '';
    prevPageUrl = json['prev_page_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total;
    data['per_page'] = perPage;
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['next_page_url'] = nextPageUrl;
    data['prev_page_url'] = prevPageUrl;
    return data;
  }
}
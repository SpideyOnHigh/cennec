
import 'dart:convert';

import 'package:cennec/modules/chat/models/MessageRoomResponse.dart';
import 'package:cennec/modules/chat/models/SendMessageResponse.dart';

import '../../core/api_service/api_provider.dart';
import 'package:http/http.dart' as http;

import '../models/MessageListResponse.dart';

class Repositorychat{
  static final Repositorychat _repository = Repositorychat._internal();
  factory Repositorychat() {
    return _repository;
  }

  /// A private constructor.
  Repositorychat._internal();

  Future<MessageListResponse> getMessageList(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    MessageListResponse result = MessageListResponse.fromJson(jsonDecode(response));
    return result;
  }

  Future<MessageRoomResponse> getMessageRoomData(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callGetMethod(client, url, header);
    MessageRoomResponse result = MessageRoomResponse.fromJson(jsonDecode(response));
    return result;
  }

  Future<SendMessageResponse> sendMessageApiData(
      String url,
      Map<String, String> header,
      Map<String, dynamic> body,
      ApiProvider mApiProvider,
      http.Client client,
      ) async {
    final response = await mApiProvider.callPostMethod(client, url,body, header);
    SendMessageResponse result = SendMessageResponse.fromJson(jsonDecode(response));
    return result;
  }
}
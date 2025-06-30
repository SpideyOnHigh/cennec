import 'package:bloc/bloc.dart';
import 'package:cennec/modules/chat/models/MessageRoomResponse.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../core/api_service/api_provider.dart';
import '../../core/api_service/error_model.dart';
import '../../core/utils/validation_string.dart';
import '../repository/RepositoryChat.dart';

part 'message_room_event.dart';
part 'message_room_state.dart';

class MessageRoomBloc extends Bloc<MessageRoomEvent, MessageRoomState> {
  MessageRoomBloc({
    required Repositorychat repositoryChat,
    required ApiProvider apiProvider,
    required http.Client client,
  })
      : mRepositoryChat = repositoryChat,
        mApiProvider = apiProvider,
        mClient = client,
        super(MessageRoomInitial()) {
    on<GetMessageRoomData>(GetMessageListApi);
  }

  final Repositorychat mRepositoryChat;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void GetMessageListApi(
      GetMessageRoomData event,
      Emitter<MessageRoomState> emit
      ) async{
    emit(MessageRoomLoading());
    try{
      MessageRoomResponse response = await mRepositoryChat.getMessageRoomData(
          event.url, await mApiProvider.getHeaderValueWithToken(), mApiProvider, mClient);
    if(response.success){
    emit(MessageRoomSuccess(response: response));
    } else{
    emit(MessageRoomFailure(errorMessage: response.error ?? ModelError()));
    }
    }catch(e){
    print('error $e');
    emit(MessageRoomFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
    }
  }
}

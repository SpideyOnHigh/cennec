import 'package:cennec/modules/chat/repository/RepositoryChat.dart';
import 'package:cennec/modules/core/utils/common_import.dart';

import '../../core/api_service/error_model.dart';
import 'package:http/http.dart' as http;

import '../models/MessageListResponse.dart';

part 'message_list_event.dart';

part 'message_list_state.dart';

class MessageListBloc extends Bloc<MessageListEvent, MessageListState> {
  MessageListBloc({
    required Repositorychat repositoryChat,
    required ApiProvider apiProvider,
    required http.Client client,
  })
      : mRepositoryChat = repositoryChat,
        mApiProvider = apiProvider,
        mClient = client,
        super(MessageListInitial()) {
    on<GetMessageList>(GetMessageListApi);
  }

  final Repositorychat mRepositoryChat;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void GetMessageListApi(GetMessageList event,
      Emitter<MessageListState> emit) async {
    emit(MessageListLoading());
    try{
      MessageListResponse response = await mRepositoryChat.getMessageList(
          event.url, await mApiProvider.getHeaderValueWithToken(), mApiProvider, mClient);
      if(response.success){
        emit(MessageListSuccess(modelSuccess: response));
      } else{
        emit(MessageListFailure(errorMessage: response.error ?? ModelError()));
      }
    }catch(e){
      print('error $e');
      emit(MessageListFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
    }
  }

}

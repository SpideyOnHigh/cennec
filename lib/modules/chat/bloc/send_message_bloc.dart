import 'package:bloc/bloc.dart';
import 'package:cennec/modules/chat/models/SendMessageResponse.dart';
import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../core/api_service/api_provider.dart';
import '../../core/utils/validation_string.dart';
import '../repository/RepositoryChat.dart';

part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  SendMessageBloc({
    required Repositorychat repositoryChat,
    required ApiProvider apiProvider,
    required http.Client client,
  })
      : mRepositoryChat = repositoryChat,
        mApiProvider = apiProvider,
        mClient = client,
        super(SendMessageInitial()) {
    on<SendMessageApiEvent>(SendMessageApi);
  }

  final Repositorychat mRepositoryChat;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void SendMessageApi(
      SendMessageApiEvent event,
      Emitter<SendMessageState> emit
      ) async{
    emit(SendMessageLoading());
    try{
      SendMessageResponse response = await mRepositoryChat.sendMessageApiData(
          event.url, await mApiProvider.getHeaderValueWithToken(),event.body, mApiProvider, mClient);
    if(response.success!){
    emit(SendMessageSuccess(messageResponse: response));
    } else{
    emit(SendMessageFailure(modelError: response.error ?? ModelError()));
    }
    }catch(e){
    print('error $e');
    emit(SendMessageFailure(modelError:ModelError(generalError: ValidationString.validationInternalServerIssue)));
    }
  }

}

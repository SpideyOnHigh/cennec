import 'package:cennec/modules/chat/bloc/message_room_bloc.dart';
import 'package:cennec/modules/chat/bloc/send_message_bloc.dart';
import 'package:cennec/modules/chat/models/MessageRoomRequestData.dart';
import 'package:cennec/modules/chat/models/MessageRoomResponse.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:cennec/modules/preferences/bloc/report_user/report_user_bloc.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../FirebaseNotificationHelper.dart';
import '../../core/common/modelCommon/ModalNotificationData.dart';
import '../../core/common/widgets/dialog/common_loading_animation.dart';
import '../../core/common/widgets/dialog/cupertino_confirmation_dialog.dart';
import '../../core/common/widgets/toast_controller.dart';
import '../../core/utils/app_config.dart';
import '../../core/utils/app_urls.dart';

class ScreenChatsModule extends StatefulWidget {
  const ScreenChatsModule({super.key, required this.messageRoomRequestData});
  final MessageRoomRequestData messageRoomRequestData;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ScreenChatsModule> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _textController = TextEditingController();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isSendLoader = ValueNotifier(false);
  ValueNotifier<List<MessageModel>> messageList = ValueNotifier([]);
  ValueNotifier<bool> isNextPage = ValueNotifier(false);
  ValueNotifier<bool> mPagination = ValueNotifier(false);
  ValueNotifier<bool> fromSendMessage = ValueNotifier(false);
  double positionValue = 0.0;
  ScrollController chatScrollController = ScrollController();
  ValueNotifier<int> mNextPage = ValueNotifier(1);
  ValueNotifier<int> totalMessages = ValueNotifier(0);
  ValueNotifier<String> nextUrl = ValueNotifier('');
  ValueNotifier<String> prevUrl = ValueNotifier('');
  ValueNotifier<String> currentUrl = ValueNotifier('');
  bool isReported = false;
  bool reportedByMe = false;
  late StreamSubscription<ModelNotificationData> chatStream;

  @override
  void initState() {
    chatScrollController.addListener(scrollListener);
    getMessageRoomData();
    printWrapped('current RouteName ${getCurrentRouteName()}');
    /*Timer.periodic(const Duration(seconds: 10), (timer) {
      fromSendMessage.value = true;
      getMessageRoomData();
    });*/
    subscribeChatNotificationStream();
    super.initState();
  }

  Widget getBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        appbar(),
        const Divider(
          height: Dimens.margin2,
        ),
        Expanded(child: _buildMessageList()),
        Visibility(
            visible: !isReported,
            replacement: Center(
              child: Text(
                "You cannot send message to this user",
                style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, Theme.of(context).colorScheme.secondary, FontWeight.w600),
              ),
            ),
            child: _buildInputField()),
      ],
    );
  }

  Widget appbar() {
    return SizedBox(
      height: Dimens.margin60,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              getCurrentChatUserId.value = 0;// replaced from dispose to here
              Navigator.pop(context);
            },
            child: Image.asset(
              APPImages.icBack,
              color: Theme.of(context).colorScheme.onSecondary, // Update with your logo path
              height: Dimens.margin25,
              width: Dimens.margin25,
            ),
          ),
          const SizedBox(
            width: Dimens.margin5,
          ),
          widget.messageRoomRequestData.imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.margin70),
                  child: Image.network(
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Image is fully loaded
                      }
                      return const Center(
                        child: CommonLoadingAnimation(), // Show the loading animation
                      );
                    },
                    widget.messageRoomRequestData.imageUrl,
                    width: Dimens.margin40,
                    height: Dimens.margin40,
                    fit: BoxFit.cover,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.margin70),
                  child: SizedBox(
                    width: Dimens.margin40,
                    height: Dimens.margin40,
                    child: Image.asset(
                      APPImages.icDummyProfile,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          const SizedBox(
            width: Dimens.margin20,
          ),
          Expanded(
            child: Text(
              overflow: TextOverflow.ellipsis,
              widget.messageRoomRequestData.name,
              style: getTextStyleFromFont(AppFont.poppins, Dimens.margin25, Theme.of(context).colorScheme.onPrimary, FontWeight.w600),
            ),
          ),
          InkWell(
            onTap: () {
              if(!reportedByMe) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) =>
                      CupertinoConfirmationDialog(
                        title: "Report User",
                        description: "Are you sure you want to report this user?",
                        cancelText: "Cancel",
                        confirmText: "OK",
                        onCancel: () {
                          Navigator.pop(context);
                        },
                        onConfirm: () {
                          reportUser(widget.messageRoomRequestData.fromUserId ?? 0);
                          printWrapped("pressed key");
                          Navigator.pop(context);
                        },
                      ),
                );
              }
              else
                {
                  ToastController.showToast(context, "You have already reported this user", false);
                }
            },
            child: SizedBox(height: 25, width: 25, child: SvgPicture.asset(APPImages.icFlagSvg)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiValueListenableBuilder(
          valueListenables: [messageList, isLoading, isNextPage, nextUrl, prevUrl, mNextPage, mPagination, isSendLoader, getCurrentChatUserId],
          builder: (context, values, child) {
            return MultiBlocListener(
              listeners: [
                BlocListener<MessageRoomBloc, MessageRoomState>(
                  listener: (context, state) {
                    isLoading.value = state is MessageRoomLoading;
                    if (state is MessageRoomFailure) {
                      if (state.errorMessage.generalError!.isNotEmpty) {
                        ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                      }
                    }
                    if (state is MessageRoomSuccess) {
                      getCurrentChatUserId.value = widget.messageRoomRequestData.fromUserId;// replaced from init to here
                      if (state.response.isReported) {
                        isReported = true;
                      }
                      if (state.response.reportedByMe) {
                        reportedByMe = true;
                      }
                      //remove duplicates
                      if (fromSendMessage.value) {
                        fromSendMessage.value = false;
                        if (state.response.pagination.total! != totalMessages.value) {
                          messageList.value.clear();
                          messageList.value.addAll(state.response.data);
                        }
                      } else {
                        messageList.value.addAll(state.response.data);
                      }
                      if (state.response.pagination.lastPage! > state.response.pagination.currentPage!) {
                        mNextPage.value++;
                        prevUrl.value = state.response.pagination.prevPageUrl!;
                        nextUrl.value = state.response.pagination.nextPageUrl!;
                        mPagination.value = false;
                        isNextPage.value = true;
                        totalMessages.value = state.response.pagination.total!;
                        print('from true');
                      } else {
                        print('from false');
                        isNextPage.value = false;
                      }
                    }
                  },
                ),
                BlocListener<SendMessageBloc, SendMessageState>(
                  listener: (context, state) {
                    // isLoading.value = state is MessageRoomLoading;
                    isSendLoader.value = state is SendMessageLoading;
                    if (state is SendMessageFailure) {
                      if (state.modelError.generalError!.isNotEmpty) {
                        ToastController.showToast(context, state.modelError.generalError ?? '', false);
                      }
                      if (state.modelError.userReported != null) {
                        ToastController.showToast(context, state.modelError.userReported ?? '', false);
                        isReported = true;
                      }
                    }
                    if (state is SendMessageSuccess) {
                      _textController.clear();
                      chatScrollController.jumpTo(0.0);
                      setState(() {
                        messageList.value.insert(
                            0,
                            MessageModel(
                                id: state.messageResponse.data!.id,
                                messageContent: state.messageResponse.data!.messageContent,
                                status: state.messageResponse.data!.status,
                                date: state.messageResponse.data!.date,
                                time: state.messageResponse.data!.time,
                                isMe: state.messageResponse.data!.isMe));
                      });
                    }
                  },
                ),
                BlocListener<ReportUserBloc, ReportUserState>(
                  listener: (context, state) {
                    isLoading.value = state is ReportUserLoading;
                    if (state is ReportUserFailure) {
                      if (state.errorMessage.generalError!.isNotEmpty) {
                        ToastController.showToast(context, state.errorMessage.generalError ?? '', false);
                      }
                    }
                    if (state is ReportUserResponse) {
                      reportedByMe = true;
                      ToastController.showToast(context, state.modelReport.message ?? '', true);
                      Navigator.pop(context, true);
                      // modelFetchUserDetail = state.modelFetchUserDetail;
                    }
                  },
                ),
              ],
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: IgnorePointer(
                    ignoring: isLoading.value || isSendLoader.value,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        children: [
                          getBody(),
                          Visibility(
                              visible: isLoading.value,
                              child: const Center(
                                child: CommonLoadingAnimation(),
                              ))
                        ],
                      ),
                    )),
              ),
            );
          }),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      reverse: true,
      physics: const BouncingScrollPhysics(),
      controller: chatScrollController,
      itemCount: messageList.value.length,
      itemBuilder: (context, index) => _buildMessageItem(messageList.value[index]),
    );
  }

  Widget _buildMessageItem(MessageModel message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BubbleNormal(
                padding: EdgeInsets.zero,
                bubbleRadius: Dimens.margin30,
                text: message.messageContent,
                isSender: message.isMe,
                color: Theme.of(context).colorScheme.onSecondary,
                tail: true,
                textStyle: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, Theme.of(context).primaryColor, FontWeight.w600)
            ),
          ),
          Text(
            message.getTimeToLocal,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: BubbleNormal(
          //       padding: EdgeInsets.zero,
          //       bubbleRadius: Dimens.margin30,
          //       text: 'bubble normal with tail',
          //       isSender: !message['isMe'],
          //       color: Colors.grey.withOpacity(0.3),
          //       tail: true,
          //       textStyle: getTextStyleFromFont(AppFont.visby, Dimens.margin18, Theme.of(context).colorScheme.onPrimary, FontWeight.w600)),
          // ),
          // Text(
          //   '${message['timestamp'].month}/${message['timestamp'].day}/${message['timestamp'].year}',
          //   style: TextStyle(fontSize: 12, color: Colors.grey),
          // ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: BaseTextFormFieldRounded(
        hintText: "Write your text..",
        hintStyle: getTextStyleFromFont(AppFont.poppins, Dimens.margin18, Theme.of(context).colorScheme.secondary, FontWeight.w600),
        controller: _textController,
        onSubmit: () => _handleSubmitted(_textController.text),
        borderRadius: Dimens.margin10,
        suffixIcon: Visibility(
          visible: isSendLoader.value,
          replacement: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
          child: Container(
              margin: const EdgeInsets.all(8),
              child: const CommonLoadingAnimation(
                size: 30,
              )),
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    // _textController.clear();
    if (_textController.text.isNotEmpty) {
      sendMessageRequest();
      // FocusScope.of(context).unfocus();
    }
/*
    setState(() {
      _messages.add({
        'text': text,
        'isMe': true,
        'timestamp': DateTime.now(),
      });
    });
*/
  }

  void subscribeChatNotificationStream() {
    chatStream = FirebaseNotificationHelper.chatStreamController.stream.listen((event) {
      printWrapped("test Stream ${event.senderUserId}");
      mPagination.value = false;
      mNextPage.value = 1;
      setState(() {
        if (int.parse(event.senderUserId) == widget.messageRoomRequestData.fromUserId) {
          messageList.value.insert(
              0,
              MessageModel(
                  id: int.parse(event.id), messageContent: event.messageContent, status: event.status, date: event.date, time: event.time, isMe: false));
          chatScrollController.jumpTo(0.0);
        } else {}
      });
    });
  }

  @override
  void dispose() {
    chatStream.cancel();
    super.dispose();
  }

  void scrollListener() {
    printWrapped("_scrollController.offset--${chatScrollController.offset}");
    printWrapped("isNextPage--${isNextPage.value}");
    printWrapped("isNextPage--${mPagination.value}");
    printWrapped("_scrollController.position.minScrollExtent--${chatScrollController.position.minScrollExtent}");
    if (chatScrollController.offset == chatScrollController.position.maxScrollExtent && !isLoading.value && !mPagination.value && isNextPage.value) {
      // mPagination.value = true;
      positionValue = chatScrollController.offset;
      mPagination.value = true;

      /// api called
      getMessageRoomData();
    }
  }

  void getMessageRoomData() {
    String url = '';
    if (mNextPage.value == 1) {
      url = AppUrls.apiGetMessageRoomData(widget.messageRoomRequestData.fromUserId, 1);
    } else {
      url = AppUrls.apiGetMessageRoomData(widget.messageRoomRequestData.fromUserId, mNextPage.value);
    }
    currentUrl.value = url;
    if (!isLoading.value) {
      BlocProvider.of<MessageRoomBloc>(context).add(GetMessageRoomData(url: url));
    }
  }

  void sendMessageRequest() {
    String url = AppUrls.apiPostSendMessage;
    Map<String, String> body = {};
    body.addAll({'receiver_user_id': widget.messageRoomRequestData.fromUserId.toString(), 'message_content': _textController.text});
    BlocProvider.of<SendMessageBloc>(context).add(SendMessageApiEvent(url: url, body: body));
  }

  void reportUser(int toUserId) {
    Map<String, dynamic> body = {
      AppConfig.paramReportBy: getUser().userData?.id ?? 0,
      AppConfig.paramReportTo: toUserId,
    };

    BlocProvider.of<ReportUserBloc>(context).add(ReportUser(url: AppUrls.apiReportUser, body: body));
  }
}

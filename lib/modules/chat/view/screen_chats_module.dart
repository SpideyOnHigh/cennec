import 'package:cennec/modules/chat/bloc/message_room_bloc.dart';
import 'package:cennec/modules/chat/bloc/send_message_bloc.dart';
import 'package:cennec/modules/chat/models/MessageRoomRequestData.dart';
import 'package:cennec/modules/chat/models/MessageRoomResponse.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:cennec/modules/preferences/bloc/report_user/report_user_bloc.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

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
                style: getTextStyleFromFont(AppFont.poppins, Dimens.margin18,
                    Theme.of(context).colorScheme.secondary, FontWeight.w600),
              ),
            ),
            child: _buildInputField()),
      ],
    );
  }

  Widget appbar() {
    return Container(
      height: Dimens.margin60,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              getCurrentChatUserId.value = 0; // replaced from dispose to here
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(
            width: Dimens.margin15,
          ),
          widget.messageRoomRequestData.imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Image is fully loaded
                      }
                      return const Center(
                        child:
                            CommonLoadingAnimation(), // Show the loading animation
                      );
                    },
                    widget.messageRoomRequestData.imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey[300],
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
          const SizedBox(
            width: Dimens.margin15,
          ),
          Expanded(
            child: Text(
              widget.messageRoomRequestData.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () {
              _showMenuBottomSheet();
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenuBottomSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              if (!reportedByMe) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoConfirmationDialog(
                    title: "Report User",
                    description: "Are you sure you want to report this user?",
                    cancelText: "Cancel",
                    confirmText: "OK",
                    onCancel: () => Navigator.pop(context),
                    onConfirm: () {
                      reportUser(widget.messageRoomRequestData.fromUserId ?? 0);
                      Navigator.pop(context);
                    },
                  ),
                );
              } else {
                ToastController.showToast(
                    context, "You have already reported this user", false);
              }
            },
            isDestructiveAction: true,
            child: const Text('Report'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Add your block logic here
            },
            isDestructiveAction: true,
            child: const Text('Block'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
          isDefaultAction: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiValueListenableBuilder(
          valueListenables: [
            messageList,
            isLoading,
            isNextPage,
            nextUrl,
            prevUrl,
            mNextPage,
            mPagination,
            isSendLoader,
            getCurrentChatUserId
          ],
          builder: (context, values, child) {
            return MultiBlocListener(
              listeners: [
                BlocListener<MessageRoomBloc, MessageRoomState>(
                  listener: (context, state) {
                    isLoading.value = state is MessageRoomLoading;
                    if (state is MessageRoomFailure) {
                      if (state.errorMessage.generalError!.isNotEmpty) {
                        ToastController.showToast(context,
                            state.errorMessage.generalError ?? '', false);
                      }
                    }
                    if (state is MessageRoomSuccess) {
                      getCurrentChatUserId.value = widget.messageRoomRequestData
                          .fromUserId; // replaced from init to here
                      if (state.response.isReported) {
                        isReported = true;
                      }
                      if (state.response.reportedByMe) {
                        reportedByMe = true;
                      }
                      //remove duplicates
                      if (fromSendMessage.value) {
                        fromSendMessage.value = false;
                        if (state.response.pagination.total! !=
                            totalMessages.value) {
                          messageList.value.clear();
                          messageList.value.addAll(state.response.data);
                        }
                      } else {
                        messageList.value.addAll(state.response.data);
                      }
                      if (state.response.pagination.lastPage! >
                          state.response.pagination.currentPage!) {
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
                        ToastController.showToast(context,
                            state.modelError.generalError ?? '', false);
                      }
                      if (state.modelError.userReported != null) {
                        ToastController.showToast(context,
                            state.modelError.userReported ?? '', false);
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
                                messageContent:
                                    state.messageResponse.data!.messageContent,
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
                        ToastController.showToast(context,
                            state.errorMessage.generalError ?? '', false);
                      }
                    }
                    if (state is ReportUserResponse) {
                      reportedByMe = true;
                      ToastController.showToast(
                          context, state.modelReport.message ?? '', true);
                      Navigator.pop(context, true);
                      // modelFetchUserDetail = state.modelFetchUserDetail;
                    }
                  },
                ),
              ],
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Color(0xFFF0F0F0),
                body: IgnorePointer(
                    ignoring: isLoading.value || isSendLoader.value,
                    child: Stack(
                      children: [
                        getBody(),
                        Visibility(
                            visible: isLoading.value,
                            child: const Center(
                              child: CommonLoadingAnimation(),
                            ))
                      ],
                    )),
              ),
            );
          }),
    );
  }

  Widget _buildMessageList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        controller: chatScrollController,
        itemCount: messageList.value.length,
        itemBuilder: (context, index) =>
            _buildMessageItem(messageList.value[index]),
      ),
    );
  }

  Widget _buildMessageItem(MessageModel message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(
                  right: 8,
                  bottom:
                      4), // Reduced bottom margin since timestamp is now inside
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: widget.messageRoomRequestData.imageUrl.isNotEmpty
                    ? Image.network(
                        widget.messageRoomRequestData.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.person, color: Colors.white, size: 16),
              ),
            ),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isMe
                    ? AppColors.chatBubbleBg
                    : AppColors.chatBubbleBg,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: message.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Message content
                  Container(
                    width: double.infinity,
                    child: Text(
                      message.messageContent,
                      style: getTextStyleFromFont(AppFont.poppins, 14,
                          AppColors.colorBlack, FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Timestamp inside the bubble at bottom
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: message.isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Text(
                        getRelativeTime(message
                            .getLocalDateTime), // Your relative time function
                        style: getTextStyleFromFont(AppFont.poppins, 14,
                            Colors.black.withOpacity(0.5), FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe) ...[
            Container(
              width: 30,
              height: 30,
              margin:
                  EdgeInsets.only(left: 8, bottom: 4), // Reduced bottom margin
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: (text) => _handleSubmitted(text),
                decoration: InputDecoration(
                  hintText: "Write here...",
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 4),
              child: Visibility(
                visible: isSendLoader.value,
                replacement: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_forward,
                          color: Colors.white, size: 16),
                      onPressed: () => _handleSubmitted(_textController.text),
                    ),
                  ),
                ),
                child: Container(
                    margin: const EdgeInsets.all(8),
                    child: const CommonLoadingAnimation(
                      size: 30,
                    )),
              ),
            ),
          ],
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
    chatStream =
        FirebaseNotificationHelper.chatStreamController.stream.listen((event) {
      printWrapped("test Stream ${event.senderUserId}");
      mPagination.value = false;
      mNextPage.value = 1;
      setState(() {
        if (int.parse(event.senderUserId) ==
            widget.messageRoomRequestData.fromUserId) {
          messageList.value.insert(
              0,
              MessageModel(
                  id: int.parse(event.id),
                  messageContent: event.messageContent,
                  status: event.status,
                  date: event.date,
                  time: event.time,
                  isMe: false));
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
    printWrapped(
        "_scrollController.position.minScrollExtent--${chatScrollController.position.minScrollExtent}");
    if (chatScrollController.offset ==
            chatScrollController.position.maxScrollExtent &&
        !isLoading.value &&
        !mPagination.value &&
        isNextPage.value) {
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
      url = AppUrls.apiGetMessageRoomData(
          widget.messageRoomRequestData.fromUserId, 1);
    } else {
      url = AppUrls.apiGetMessageRoomData(
          widget.messageRoomRequestData.fromUserId, mNextPage.value);
    }
    currentUrl.value = url;
    if (!isLoading.value) {
      BlocProvider.of<MessageRoomBloc>(context)
          .add(GetMessageRoomData(url: url));
    }
  }

  void sendMessageRequest() {
    String url = AppUrls.apiPostSendMessage;
    Map<String, String> body = {};
    body.addAll({
      'receiver_user_id': widget.messageRoomRequestData.fromUserId.toString(),
      'message_content': _textController.text
    });
    BlocProvider.of<SendMessageBloc>(context)
        .add(SendMessageApiEvent(url: url, body: body));
  }

  void reportUser(int toUserId) {
    Map<String, dynamic> body = {
      AppConfig.paramReportBy: getUser().userData?.id ?? 0,
      AppConfig.paramReportTo: toUserId,
    };

    BlocProvider.of<ReportUserBloc>(context)
        .add(ReportUser(url: AppUrls.apiReportUser, body: body));
  }

  // Add this helper function to your _ChatScreenState class or create a separate utility class

  String getRelativeTime(DateTime messageTime) {
    final now = DateTime.now();
    final difference = now.difference(messageTime);

    if (difference.inSeconds < 60) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    }
  }

// Alternative function that shows full date/time for very old messages
  String getSmartRelativeTime(DateTime messageTime) {
    final now = DateTime.now();
    final difference = now.difference(messageTime);

    if (difference.inSeconds < 60) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      // For messages older than a week, show actual date
      return DateFormat('MMM dd, yyyy').format(messageTime);
    }
  }
}

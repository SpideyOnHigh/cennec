import 'package:cennec/modules/chat/models/MessageRoomRequestData.dart';
import 'package:cennec/modules/connections/model/model_send_request.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'modules/core/common/modelCommon/ModalNotificationData.dart';
import 'modules/core/utils/common_import.dart';
import 'modules/core/api_service/preference_helper.dart';

class FirebaseNotificationHelper {
  static const String _notificationTypeChat = 'chat';
  static const String _notificationTypeConnectionRequest = 'connection_request';
  static const String _channelId = 'cennec';
  static const String _channelName = 'Cennec Notifications';
  var notificationId;


  static final FirebaseNotificationHelper _instance = FirebaseNotificationHelper._internal();

  factory FirebaseNotificationHelper() => _instance;

  FirebaseNotificationHelper._internal();

  static final StreamController<ModelNotificationData> chatStreamController = StreamController.broadcast();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    APPStrings.appName,
    APPStrings.appName,
    importance: Importance.high,
    showBadge: true,
    enableVibration: true,
    playSound: true,
  );

  Future<String?> getFcmToken() async {
    return await _firebaseMessaging.getToken();
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      _handleNotificationClick(notificationResponse.payload!);
    }
  }

  Future<void> init({BackgroundMessageHandler? handler}) async {
    printWrapped("in init=======================");
    if (handler != null) {
      FirebaseMessaging.onBackgroundMessage(handler);
    }

    await _initializeNotificationChannels();
    await _configureForegroundNotificationOptions();
    await _initializeLocalNotifications();

    String? token = await _firebaseMessaging.getToken();
    await _saveFcmToken(token);

    _setupNotificationListeners();
  }

  Future<void> _initializeNotificationChannels() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _configureForegroundNotificationOptions() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_bottom_cennec');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  void _onNotificationResponse(NotificationResponse details) {
    print("Payload of notification >>> ${jsonEncode(details.payload)}");
    if (details.payload != null) {
      _handleNotificationClick(details.payload!);
    }
  }

  Future<void> _saveFcmToken(String? token) async {
    if (token != null) {
      PreferenceHelper.setString(PreferenceHelper.fcmToken, token);
    }
  }

  void _setupNotificationListeners() {
    printWrapped("_setupNotificationListeners");
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpenedApp);
    FirebaseMessaging.instance.getInitialMessage().then(_handleInitialMessage);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    printWrapped("message = $message =====================================");
    _showNotification(message);
  }

  void _handleNotificationOpenedApp(RemoteMessage message) {
    _handleNotificationClickIOS(message.data);
  }

  void _handleInitialMessage(RemoteMessage? message) {
    if (message != null) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        _handleNotificationClickIOS(message.data);
      });
    }
  }

  void _showNotification(RemoteMessage message) async {
    printWrapped("message data = ${message.data}");
    if (message.data['notification_type'] == _notificationTypeChat) {
      if (_shouldShowChatNotification(message)) {
        if (Platform.isAndroid) {
          _displayLocalNotification(message);
        }
        // For iOS, FCM will handle the notification display
      } else {
        if(Platform.isIOS)
          {
            printWrapped("id = $notificationId");
            printWrapped("message.data[id] = ${message.data["id"]}");
            if(message.data["id"] != notificationId)
              {
                notificationId = message.data["id"];
                _addToChatStream(message);
              }
          }
        if(Platform.isAndroid)
          {
            _addToChatStream(message);
          }
      }
    }
    else
      {
        if (Platform.isAndroid) {
          _displayLocalNotification(message);
        }
      }
  }

  bool _shouldShowChatNotification(RemoteMessage message) {
    return getCurrentRouteName() != AppRoutes.routesScreenChats || getCurrentChatUserId.value != int.parse(message.data['sender_user_id']);
  }

  void _addToChatStream(RemoteMessage message) {
    try {
      chatStreamController.add(ModelNotificationData.fromJson(message.data));
    } catch (e) {
      print('Error adding to chat stream: $e');
    }
  }

  void _displayLocalNotification(RemoteMessage message) async {
    if (Platform.isAndroid) {
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          icon: 'ic_bottom_cennec',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      );

      await _flutterLocalNotificationsPlugin.show(
        message.hashCode, // Use a unique identifier
        message.data['sender_user_name'] ?? APPStrings.appName,
        message.data['message_content'] ?? "New Message Received!",
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    }
  }

  Future<void> _handleNotificationClick(String payload) async {
    final Map<String, dynamic> data = jsonDecode(payload);
    _notificationRedirection(data);
  }

  Future<void> _handleNotificationClickIOS(Map<String, dynamic> payload) async {
    _notificationRedirection(payload);
  }

  static void _notificationRedirection(Map<String, dynamic> payload) {
    final BuildContext context = getNavigatorKeyContext();
    if (PreferenceHelper.getString(PreferenceHelper.userToken)!.isNotEmpty) {
      switch (payload['notification_type']) {
        case _notificationTypeChat:
          Navigator.pushNamed(
            context,
            AppRoutes.routesScreenChats,
            arguments: MessageRoomRequestData(
              fromUserId: int.parse(payload['sender_user_id'] ?? 0),
              page: 1,
              name: payload['sender_user_name'] ?? '',
              imageUrl: payload['sender_user_profile_image'] ?? '',
            ),
          );
          break;
        case _notificationTypeConnectionRequest:
          Navigator.pushNamed(context, AppRoutes.routesScreenUserDetails,
              arguments: ModelRequestDataTransfer(getUserId: int.parse(payload['sender_user_id'] ?? 0) , isFromDashboard: true));
          break;
        default:
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.routesScreenDashboard, (route) => false);
          break;
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.routesLogin, (route) => false);
    }
  }

  void clearAllNotifications() {
    _flutterLocalNotificationsPlugin.cancelAll();
  }
}
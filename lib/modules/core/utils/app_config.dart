/// It's a Dart class that has a single static method called `fromJson` that takes a `Map<String,
/// dynamic>` and returns an instance of the class
class AppConfig {
  ///static const String baseUrl = 'https://mydomain.com/api/v1/';
  static String googleMapApiKey = 'AIzaSyAS7nYuGVmzemJJcFMTy8L6iTwx335URgY';

  ///Header Key and Value
  static const String xContentType = 'Content-Type';
  static const String xApplicationJson = 'application/json';
  static const String xAcceptDeviceType = 'accept-device-type';
  static const String xAcceptDevice1 = '1';
  static const String xAuthorization = 'Authorization';
  static const String xAcceptAppVersion = 'accept-version';
  static const String xAcceptType = 'Accept-type';
  static const String xAccept = 'Accept';
  static const String xPage = 'page';
  static const String xAcceptDeviceIOS = '1';
  static const String xAcceptDeviceAndroid = '2';
  static const String xAcceptDeviceWeb = '3';
  static const String xUserTimeZone = 'user_tz';

  /// Dark Theme Hive
  static const String hiveThemeBox = 'themeBox';
  static const String hiveThemeData = 'themeData';

  static const String pageLimit = '10';
  static const int pageLimitCount = 10;

  static const String paramEmail = 'email';
  static const String paramPassword = 'password';
  static const String paramToken = 'fcm_token';
  static const String paramCnfPassword = 'confirm_password';
  static const String paramInvCode = 'invitation_code';
  static const String paramOtp = 'otp';
  static const String paramUserName = 'username';
  static const String paramName = 'name';
  static const String paramDOB = 'dob';
  static const String paramGender = 'gender';
  static const String paramCurrentPwd = 'current_password';
  static const String paramNewPwd = 'new_password';
  static const String paramUserId = 'user_id';
  static const String paramInterestsId = 'interest_id';
  static const String paramTermCondition = 'terms-conditions';
  static const String paramPrivacyPolicy = 'privacy-policy';
  static const String paramFavouriteBy = 'favorited_by_user_id';
  static const String paramFavouriteTo = 'favorited_user_id';
  static const String paramBlockedBy = 'blocked_by_user_id';
  static const String paramBlockedTo = 'blocked_user_id';
  static const String paramReportBy = 'reported_by_user_id';
  static const String paramReportTo = 'reported_user_id';
  static const String paramActionBy = 'action_by';
  static const String paramActionTo = 'action_to';
  static const String paramRequestStatus = 'request_status';
  static const String paramNotificationId = 'notification_id';
  static const String paramAccepted = 'accepted';
  static const String paramRejected = 'rejected';
  static const String paramBio = 'bio';
  static const String paramLocation = 'location';
  static const String paramLatitude = 'latitude';
  static const String paramLongitude = 'longitude';
  static const String paramIsSmoke = 'is_smoke';
  static const String paramIsDrink = 'is_drink';
  static const String paramQueAns = 'que_ans';
  static const String paramRating = 'rating';
  static const String paramFeedbackType = 'feedback_type_id';
  static const String paramComment = 'comment';
  static const String paramAboutUs = 'about-us';
  static const String paramGuidelines = 'community-guidlines';
  //messages
  static const String paramFromUserId = 'from_user_id';
  static const String paramPage = 'page';
  static const String paramDefaultPic = 'default_profile_picture';
}

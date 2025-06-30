import 'package:flutter_flavor/flutter_flavor.dart';

class AppUrls {
  ///API NAME
  static String base = FlavorConfig.instance.variables["base"];
  static String baseUrl = '${base}api/';
  static String apiUserLogin = '${baseUrl}login';
  static String apiUserLogout = '${baseUrl}logout';
  static String apiUserSignUpInvCode = '${baseUrl}invitation-sign-up';
  static String apiValidateOtp = '${baseUrl}valid-otp';
  static String apiSignUpDetail = '${baseUrl}sign-up-detail';
  static String apiSendResetLink = '${baseUrl}forgot-password';
  static String apiChangePwd = '${baseUrl}change-password';
  static String apiDeleteAccount = '${baseUrl}delete-my-account';
  static String apiGetUserSettings(int id) => '${baseUrl}get-user-settings?user_id=$id';
  static String apiEditUserSettings = '${baseUrl}edit-user-settings';
  static String apiResetPwd = '${baseUrl}reset-password';
  static String apiGetInterests = '${baseUrl}interest-list';
  static String apiUpdateUserInterests = '${baseUrl}edit-user-interest';
  static String apiAddInterests = '${baseUrl}add-to-my-interest';
  static String apiRemoveInterests = '${baseUrl}remove-from-my-interest';
  static String apiGetRecommendationOfInterest(int id) => '${baseUrl}interest-based-user?interest_id=$id';
  static String apiGetCmsContent(String slug) => '${baseUrl}get-policy?slug=$slug';
  static String apiFetchUserDetails(int userId) => '${baseUrl}fetch-user-detail?user_id=$userId';
  static String apiSendRequest = '${baseUrl}send-cennection-request';
  static String apiAddToFavourites = '${baseUrl}favourite-user';
  static String apiBlockUser = '${baseUrl}block-user';
  static String apiReportUser = '${baseUrl}report-user';
  static String apiGetMyInterests(int id) => '${baseUrl}my-interest?user_id=$id';
  static String apiGetProfilePrefs(int id) => '${baseUrl}get-user-profile?user_id=$id';
  static String apiGetNotification = '${baseUrl}notifications';
  static String apiAcceptRejectRequests = '${baseUrl}accp-reject-request';
  static String apiMyConnections = '${baseUrl}my-cennections';
  static String apiMessageList = '${baseUrl}recent-chat-users';
  static String apiMyFavourites = '${baseUrl}my-favourites';
  static String apiEditUserProfile = '${baseUrl}edit-user-profile';
  static String apiFetchUserQueAns(int id) => '${baseUrl}fetch-user-que-ans?user_id=$id';
  static String apiPostUserQueAns = '${baseUrl}edit-user-que-ans';
  static String apiDeleteConnection(int id) => '${baseUrl}delete-connections?friend_id=$id';
  static String apiGetFeedbackQue = '${baseUrl}fetch-feedback-que';
  static String apiPostFeedback= '${baseUrl}user-feedback';
  static String apiGetRecommendation= '${baseUrl}recomendation-user';
  static String apiGetUserPReference= '${baseUrl}user-preferences';
  static String apiRemoveFavourite(int id) => '${baseUrl}remove-favourite?favorited_user_id=$id';
  static String apiPostUserPReference= '${baseUrl}user-preferences';

  static String apiPostSendMessage = '${baseUrl}send-messages';
  static String apiPostImage = '${baseUrl}user-profile-images';
  static String apiGetMessageRoomData(int fromUserId,int page) => '${baseUrl}messages?from_user_id=$fromUserId&page=$page&per_page=15';
  static String apiPostUserAccepted(String slug) => '${baseUrl}user-policy?slug=$slug';
  static String apiGetProfilePicture= '${baseUrl}get-user-profile-images';
  static String apiSetDefaultProfilePicture= '${baseUrl}default-user-image';
  static String apiRemoveUser(int id)=> '${baseUrl}remove-user?removed_user_id=$id';
  static String apiGetRequests= '${baseUrl}pending-req-list';
}

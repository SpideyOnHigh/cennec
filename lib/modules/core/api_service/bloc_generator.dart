import 'package:cennec/modules/auth/bloc/change_or_set_new_password_bloc/change_or_set_new_pwd_bloc.dart';
import 'package:cennec/modules/auth/bloc/delete_profile_bloc/delete_profile_bloc.dart';
import 'package:cennec/modules/auth/bloc/forgot_password_email_bloc/forgot_password_email_bloc.dart';
import 'package:cennec/modules/auth/bloc/login_bloc/login_bloc.dart';
import 'package:cennec/modules/auth/bloc/logout_bloc/logout_bloc.dart';
import 'package:cennec/modules/auth/bloc/sign_up_details_fill_bloc/sign_up_details_bloc.dart';
import 'package:cennec/modules/auth/bloc/sign_up_inv_bloc/sign_up_invitation_bloc.dart';
import 'package:cennec/modules/auth/bloc/verify_sign_up_otp_bloc/verify_sign_up_otp_bloc.dart';
import 'package:cennec/modules/auth/repository/repository_auth.dart';
import 'package:cennec/modules/chat/bloc/message_list_bloc.dart';
import 'package:cennec/modules/chat/bloc/send_message_bloc.dart';
import 'package:cennec/modules/chat/repository/RepositoryChat.dart';
import 'package:cennec/modules/cms_pages/bloc/get_cms_page_bloc.dart';
import 'package:cennec/modules/cms_pages/repository/repository_cms.dart';
import 'package:cennec/modules/connections/bloc/accept-reject_requests/accept_reject_requests_bloc.dart';
import 'package:cennec/modules/connections/bloc/add_to_favourite/favourites_bloc.dart';
import 'package:cennec/modules/connections/bloc/delete_connection/delete_connection_bloc.dart';
import 'package:cennec/modules/connections/bloc/fetch_user_bloc/fetch_user_details_bloc.dart';
import 'package:cennec/modules/connections/bloc/get_my_favourites/get_my_favourites_bloc.dart';
import 'package:cennec/modules/connections/bloc/get_recommendations/get_recommendations_bloc.dart';
import 'package:cennec/modules/connections/bloc/my_connections/get_my_connections_bloc.dart';
import 'package:cennec/modules/connections/bloc/removeFromFavourite/remove_from_favourite_bloc.dart';
import 'package:cennec/modules/connections/bloc/remove_user/remove_user_bloc.dart';
import 'package:cennec/modules/connections/bloc/remove_user_from_details/remove_user_from_details_bloc.dart';
import 'package:cennec/modules/connections/bloc/send_request_bloc/send_request_bloc.dart';
import 'package:cennec/modules/connections/repository/repository_connections.dart';
import 'package:cennec/modules/core/utils/common_import.dart';
import 'package:cennec/modules/dashboard/bloc/requests_bloc/get_requests_bloc.dart';
import 'package:cennec/modules/feedback/bloc/get_feedback_que/get_feedback_que_bloc.dart';
import 'package:cennec/modules/feedback/bloc/post_feedback/post_feedback_bloc.dart';
import 'package:cennec/modules/feedback/repository/repository_feedback.dart';
import 'package:cennec/modules/infomation&guidelines/bloc/user_readed_about_us_bloc.dart';
import 'package:cennec/modules/interests/bloc/add_remove_interests/add_remove_interests_bloc.dart';
import 'package:cennec/modules/interests/bloc/get_interests/get_interests_lists_bloc.dart';
import 'package:cennec/modules/interests/bloc/get_interests_recommendation/recommendations_of_interest_bloc.dart';
import 'package:cennec/modules/interests/bloc/get_my_interests/get_my_interests_bloc.dart';
import 'package:cennec/modules/interests/bloc/update_user_interests/update_user_interests_bloc.dart';
import 'package:cennec/modules/interests/repository/interests_repository.dart';
import 'package:cennec/modules/notifications/bloc/notifications_list_bloc.dart';
import 'package:cennec/modules/notifications/repository/repository_notifications.dart';
import 'package:cennec/modules/preferences/bloc/block_user/block_user_bloc.dart';
import 'package:cennec/modules/preferences/bloc/get_user_preference/get_user_preference_bloc.dart';
import 'package:cennec/modules/preferences/bloc/post_user_preference/post_user_preference_bloc.dart';
import 'package:cennec/modules/preferences/bloc/report_user/report_user_bloc.dart';
import 'package:cennec/modules/preferences/repository/repository_preferences.dart';
import 'package:cennec/modules/profile/bloc/get_user_profile_pic/get_user_profile_pic_bloc.dart';
import 'package:cennec/modules/profile/bloc/get_user_profile_pref/get_user_profile_pref_bloc.dart';
import 'package:cennec/modules/profile/bloc/get_user_que_ans/get_user_que_ans_bloc.dart';
import 'package:cennec/modules/profile/bloc/post_profile_picture_bloc/post_profile_picture_bloc.dart';
import 'package:cennec/modules/profile/bloc/post_user_que_ans/post_user_que_ans_bloc.dart';
import 'package:cennec/modules/profile/bloc/set_default_profile_pic/set_default_profile_pic_bloc.dart';
import 'package:cennec/modules/profile/bloc/update_user_profile/update_user_profile_bloc.dart';
import 'package:cennec/modules/profile/repository/repository_profile.dart';
import 'package:cennec/modules/settings/bloc/edit_user_settings/edit_user_settings_bloc.dart';
import 'package:cennec/modules/settings/bloc/get_user_settings/get_user_setting_bloc.dart';
import 'package:cennec/modules/settings/repository/settings_repository.dart';
import 'package:http/http.dart' as http;

import '../../chat/bloc/message_room_bloc.dart';

class BlocGenerator {
  static generateBloc(
    ApiProvider apiProvider,
    http.Client client,
  ) {
    return [
      BlocProvider<LoginBloc>(
        create: (BuildContext context) => LoginBloc(apiProvider: apiProvider, client: client, repositoryAuth: RepositoryAuth()),
      ),
      BlocProvider<LogoutBloc>(
        create: (BuildContext context) => LogoutBloc(apiProvider: apiProvider, client: client, repositoryLogOut: RepositoryAuth()),
      ),
      BlocProvider<SignUpInvitationBloc>(
        create: (BuildContext context) => SignUpInvitationBloc(apiProvider: apiProvider, client: client, repositoryAuth: RepositoryAuth()),
      ),
      BlocProvider<VerifySignUpOtpBloc>(
        create: (BuildContext context) => VerifySignUpOtpBloc(apiProvider: apiProvider, client: client, repositoryAuth: RepositoryAuth()),
      ),
      BlocProvider<SignUpDetailsBloc>(
        create: (BuildContext context) => SignUpDetailsBloc(apiProvider: apiProvider, client: client, repositoryAuth: RepositoryAuth()),
      ),
      BlocProvider<ForgotPasswordEmailBloc>(
        create: (BuildContext context) => ForgotPasswordEmailBloc(apiProvider: apiProvider, client: client, repositoryAuth: RepositoryAuth()),
      ),
      BlocProvider<ChangeOrSetNewPwdBloc>(
        create: (BuildContext context) => ChangeOrSetNewPwdBloc(apiProvider: apiProvider, client: client, repositoryAuth: RepositoryAuth()),
      ),
      BlocProvider<DeleteProfileBloc>(
        create: (BuildContext context) => DeleteProfileBloc(apiProvider: apiProvider, client: client, repositoryAuth: RepositoryAuth()),
      ),
      BlocProvider<GetUserSettingBloc>(
        create: (BuildContext context) => GetUserSettingBloc(apiProvider: apiProvider, client: client, repositorySettings: RepositorySettings()),
      ),
      BlocProvider<EditUserSettingsBloc>(
        create: (BuildContext context) => EditUserSettingsBloc(apiProvider: apiProvider, client: client, repositorySettings: RepositorySettings()),
      ),
      BlocProvider<GetInterestsListsBloc>(
        create: (BuildContext context) => GetInterestsListsBloc(apiProvider: apiProvider, client: client, repositoryInterests: RepositoryInterests()),
      ),
      BlocProvider<UpdateUserInterestsBloc>(
        create: (BuildContext context) => UpdateUserInterestsBloc(apiProvider: apiProvider, client: client, repositoryInterests: RepositoryInterests()),
      ),
      BlocProvider<RecommendationsOfInterestBloc>(
        create: (BuildContext context) => RecommendationsOfInterestBloc(apiProvider: apiProvider, client: client, repositoryInterests: RepositoryInterests()),
      ),
      BlocProvider<AddRemoveInterestsBloc>(
        create: (BuildContext context) => AddRemoveInterestsBloc(apiProvider: apiProvider, client: client, repositoryInterests: RepositoryInterests()),
      ),
      BlocProvider<GetCmsPageBloc>(
        create: (BuildContext context) => GetCmsPageBloc(apiProvider: apiProvider, client: client, repositoryGetCmsPage: RepositoryGetCmsPage()),
      ),
      BlocProvider<FetchUserDetailsBloc>(
        create: (BuildContext context) => FetchUserDetailsBloc(apiProvider: apiProvider, client: client, repositoryConnections: RepositoryConnections()),
      ),
      BlocProvider<SendRequestBloc>(
        create: (BuildContext context) => SendRequestBloc(apiProvider: apiProvider, client: client, repositoryConnections: RepositoryConnections()),
      ),
      BlocProvider<FavouritesBloc>(
        create: (BuildContext context) => FavouritesBloc(apiProvider: apiProvider, client: client, repositoryConnections: RepositoryConnections()),
      ),
      BlocProvider<BlockUserBloc>(
        create: (BuildContext context) => BlockUserBloc(apiProvider: apiProvider, client: client, repositoryPreferences: RepositoryPreferences()),
      ),
      BlocProvider<ReportUserBloc>(
        create: (BuildContext context) => ReportUserBloc(apiProvider: apiProvider, client: client, repositoryPreferences: RepositoryPreferences()),
      ),
      BlocProvider<GetMyInterestsBloc>(
        create: (BuildContext context) => GetMyInterestsBloc(apiProvider: apiProvider, client: client, repositoryInterests: RepositoryInterests()),
      ),
      BlocProvider<GetUserProfilePrefBloc>(
        create: (BuildContext context) => GetUserProfilePrefBloc(apiProvider: apiProvider, client: client, repositoryProfile: RepositoryProfile()),
      ),
      BlocProvider<NotificationsListBloc>(
        create: (BuildContext context) => NotificationsListBloc(apiProvider: apiProvider, client: client, repositoryNotification: RepositoryNotification()),
      ),
      BlocProvider<AcceptRejectRequestsBloc>(
        create: (BuildContext context) => AcceptRejectRequestsBloc(apiProvider: apiProvider, client: client, repositoryConnections: RepositoryConnections()),
      ),
      BlocProvider<GetMyConnectionsBloc>(
        create: (BuildContext context) => GetMyConnectionsBloc(apiProvider: apiProvider, client: client, repositoryConnections: RepositoryConnections()),
      ),
      BlocProvider<GetMyFavouritesBloc>(
        create: (BuildContext context) => GetMyFavouritesBloc(apiProvider: apiProvider, client: client, repositoryConnections: RepositoryConnections()),
      ),
      BlocProvider<UpdateUserProfileBloc>(
        create: (BuildContext context) => UpdateUserProfileBloc(apiProvider: apiProvider, client: client, repositoryProfile: RepositoryProfile()),
      ),
      BlocProvider<GetUserQueAnsBloc>(
        create: (BuildContext context) => GetUserQueAnsBloc(apiProvider: apiProvider, client: client, repositoryProfile: RepositoryProfile()),
      ),
      BlocProvider<PostUserQueAnsBloc>(
        create: (BuildContext context) => PostUserQueAnsBloc(apiProvider: apiProvider, client: client, repositoryProfile: RepositoryProfile()),
      ),
      BlocProvider<DeleteConnectionBloc>(
        create: (BuildContext context) => DeleteConnectionBloc(apiProvider: apiProvider, client: client, repositoryConnections: RepositoryConnections()),
      ),
      BlocProvider<GetFeedbackQueBloc>(
        create: (BuildContext context) => GetFeedbackQueBloc(apiProvider: apiProvider, client: client, repositoryFeedback: RepositoryFeedback()),
      ),
      BlocProvider<PostFeedbackBloc>(
        create: (BuildContext context) => PostFeedbackBloc(apiProvider: apiProvider, client: client, repositoryFeedback: RepositoryFeedback()),
      ),
      BlocProvider<RemoveFromFavouriteBloc>(
        create: (BuildContext context) => RemoveFromFavouriteBloc(apiProvider: apiProvider, client: client, repositoryConnections: RepositoryConnections()),
      ),
      BlocProvider<GetRecommendationsBloc>(
        create: (BuildContext context) => GetRecommendationsBloc(apiProvider: apiProvider, client: client, repositoryConnections: RepositoryConnections()),
      ),
      BlocProvider<GetRecommendationsBloc>(
        create: (BuildContext context) => GetRecommendationsBloc(apiProvider: apiProvider, client: client, repositoryConnections: RepositoryConnections()),
      ),
      BlocProvider<GetUserPreferenceBloc>(
        create: (BuildContext context) => GetUserPreferenceBloc(apiProvider: apiProvider, client: client, repositoryPreferences: RepositoryPreferences()),
      ),
      BlocProvider<PostUserPreferenceBloc>(
        create: (BuildContext context) => PostUserPreferenceBloc(apiProvider: apiProvider, client: client, repositoryPreferences: RepositoryPreferences()),
      ),
      BlocProvider<MessageListBloc>(
        create: (BuildContext context) => MessageListBloc(apiProvider: apiProvider, client: client, repositoryChat: Repositorychat()),
      ),
      BlocProvider<MessageRoomBloc>(
        create: (BuildContext context) => MessageRoomBloc(apiProvider: apiProvider, client: client, repositoryChat: Repositorychat()),
      ),
      BlocProvider<SendMessageBloc>(
        create: (BuildContext context) => SendMessageBloc(apiProvider: apiProvider, client: client, repositoryChat: Repositorychat()),
      ),
      BlocProvider<UserReadedAboutUsBloc>(
        create: (BuildContext context) => UserReadedAboutUsBloc(apiProvider: apiProvider, client: client, repositoryGetCmsPage: RepositoryGetCmsPage()),
      ),
      BlocProvider<PostProfilePictureBloc>(
        create: (BuildContext context) => PostProfilePictureBloc(apiProvider: apiProvider, client: client, repositoryProfile: RepositoryProfile()),
      ),
      BlocProvider<GetUserProfilePicBloc>(
        create: (BuildContext context) => GetUserProfilePicBloc(apiProvider: apiProvider, client: client, repositoryProfile: RepositoryProfile()),
      ),
      BlocProvider<SetDefaultProfilePicBloc>(
        create: (BuildContext context) => SetDefaultProfilePicBloc(apiProvider: apiProvider, client: client, repositoryProfile: RepositoryProfile()),
      ),
      BlocProvider<RemoveUserFromInterestsBloc>(
        create: (BuildContext context) => RemoveUserFromInterestsBloc(apiProvider: apiProvider, client: client, repositoryConnections: RepositoryConnections()),
      ),
      BlocProvider<RemoveUserFromDetailsBloc>(
        create: (BuildContext context) => RemoveUserFromDetailsBloc(apiProvider: apiProvider, client: client, repositoryConnections: RepositoryConnections()),
      ),
      BlocProvider<GetRequestsBloc>(
        create: (BuildContext context) => GetRequestsBloc(apiProvider: apiProvider, client: client, repositoryConnections: RepositoryConnections()),
      ),
    ];
  }
}

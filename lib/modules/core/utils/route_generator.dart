import 'package:cennec/modules/auth/model/model_sign_up_data_transfer.dart';
import 'package:cennec/modules/auth/view/screen_VerifyEmail.dart';
import 'package:cennec/modules/auth/view/screen_change_password.dart';
import 'package:cennec/modules/auth/view/screen_set_new_pwd_forgot_flow.dart';
import 'package:cennec/modules/auth/view/screen_forgot_password_email.dart';
import 'package:cennec/modules/auth/view/screen_forgot_password_otp.dart';
import 'package:cennec/modules/auth/view/screen_login.dart';
import 'package:cennec/modules/auth/view/screen_sign_up.dart';
import 'package:cennec/modules/auth/view/screen_sign_up_user_preference.dart';
import 'package:cennec/modules/chat/models/MessageRoomRequestData.dart';
import 'package:cennec/modules/chat/view/screen_chats_module.dart';
import 'package:cennec/modules/cms_pages/view/screen_cms_pages.dart';
import 'package:cennec/modules/connections/model/model_send_request.dart';
import 'package:cennec/modules/connections/view/find_connections_signup.dart';
import 'package:cennec/modules/connections/view/screen_favourites.dart';
import 'package:cennec/modules/connections/view/screen_send_request.dart';
import 'package:cennec/modules/connections/view/screen_user_details.dart';
import 'package:cennec/modules/dashboard/view/screen_dashboard.dart';
import 'package:cennec/modules/feedback/view/screen_feedback.dart';
import 'package:cennec/modules/infomation&guidelines/view/screen_about_us.dart';
import 'package:cennec/modules/infomation&guidelines/view/screen_community_guidelines.dart';
import 'package:cennec/modules/interests/model/model_interests.dart';
import 'package:cennec/modules/interests/view/screen_recommendation_of_interests.dart';
import 'package:cennec/modules/interests/view/screen_signup_interests.dart';
import 'package:cennec/modules/notifications/view/screen_notifications.dart';
import 'package:cennec/modules/preferences/view/screen_preferences.dart';
import 'package:cennec/modules/profile/view/screen_edit_profile.dart';
import 'package:cennec/modules/settings/view/screen_settings.dart';
import 'package:cennec/modules/splash/view/screen_splash.dart';
import 'common_import.dart';

/// > RouteGenerator is a class that generates routes for the application
/// It's a class that generates routes
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.routesSplash:
        return MaterialPageRoute(builder: (_) => const ScreenSplash(), settings: const RouteSettings(name: AppRoutes.routesSplash));
      case AppRoutes.routesLogin:
        return MaterialPageRoute(builder: (_) => const ScreenLogin(), settings: const RouteSettings(name: AppRoutes.routesLogin));
      case AppRoutes.routesSignUp:
        return MaterialPageRoute(builder: (_) => const ScreenSignUp(), settings: const RouteSettings(name: AppRoutes.routesSignUp));
      case AppRoutes.routesVerifyEmail:
        return MaterialPageRoute(
            builder: (_) => ScreenVerifyEmail(
                  modelSignUpDataTransfer: args as ModelSignUpDataTransfer,
                ),
            settings: const RouteSettings(name: AppRoutes.routesVerifyEmail));
      case AppRoutes.routesForgotPwdEmail:
        return MaterialPageRoute(builder: (_) => const ScreenForgotPasswordEmail(), settings: const RouteSettings(name: AppRoutes.routesForgotPwdEmail));
      case AppRoutes.routesScreenForgotPasswordOtp:
        return MaterialPageRoute(
            builder: (_) => ScreenForgotPasswordOtp(
                  modelSignUpDataTransfer: args as ModelSignUpDataTransfer,
                ),
            settings: const RouteSettings(name: AppRoutes.routesScreenForgotPasswordOtp));
      case AppRoutes.routesSignUpUserPreference:
        return MaterialPageRoute(
            builder: (_) => ScreenSignUpUserPreference(
                  modelSignUpDataTransfer: args as ModelSignUpDataTransfer,
                ),
            settings: const RouteSettings(name: AppRoutes.routesSignUpUserPreference));
      case AppRoutes.routesScreenAboutUs:
        return MaterialPageRoute(
            builder: (_) => ScreenAboutUs(
                  isFromProfile: args as bool,
                ),
            settings: const RouteSettings(name: AppRoutes.routesScreenAboutUs));
      case AppRoutes.routesScreenSetNewPassword:
        return MaterialPageRoute(
            builder: (_) => ScreenSetNewPassword(
                  modelSignUpDataTransfer: args as ModelSignUpDataTransfer,
                ),
            settings: const RouteSettings(name: AppRoutes.routesScreenSetNewPassword));
      case AppRoutes.routesScreenCommunityGuidelines:
        return MaterialPageRoute(
            builder: (_) => const ScreenCommunityGuidelines(), settings: const RouteSettings(name: AppRoutes.routesScreenCommunityGuidelines));
      case AppRoutes.routesScreenSignupInterests:
        return MaterialPageRoute(builder: (_) => const ScreenSignupInterests(), settings: const RouteSettings(name: AppRoutes.routesScreenSignupInterests));
      case AppRoutes.routesScreenFindConnectionsSignUp:
        return MaterialPageRoute(
            builder: (_) => const ScreenFindConnectionsSignup(), settings: const RouteSettings(name: AppRoutes.routesScreenFindConnectionsSignUp));
      case AppRoutes.routesScreenDashboard:
        return MaterialPageRoute(builder: (_) => const ScreenDashboard(), settings: const RouteSettings(name: AppRoutes.routesScreenDashboard));
      case AppRoutes.routesScreenNotifications:
        return MaterialPageRoute(builder: (_) => const ScreenNotifications(), settings: const RouteSettings(name: AppRoutes.routesScreenNotifications));
      case AppRoutes.routesScreenSendRequest:
        return MaterialPageRoute(
            builder: (_) => ScreenSendRequest(
                  modelRequestDataTransfer: args as ModelRequestDataTransfer,
                ),
            settings: const RouteSettings(name: AppRoutes.routesScreenSendRequest));
      case AppRoutes.routesScreenUserDetails:
        return MaterialPageRoute(builder: (_) =>  ScreenUserDetails(modelRequestDataTransfer:  args as ModelRequestDataTransfer,), settings: const RouteSettings(name: AppRoutes.routesScreenUserDetails));
      case AppRoutes.routesScreenRecommendationOfInterests:
        return MaterialPageRoute(
            builder: (_) => ScreenRecommendationOfInterests(modelInterestsDataTransfer: args as ModelInterestsDataTransfer),
            settings: const RouteSettings(name: AppRoutes.routesScreenRecommendationOfInterests));
      case AppRoutes.routesScreenEditProfile:
        return MaterialPageRoute(builder: (_) => const ScreenEditProfile(), settings: const RouteSettings(name: AppRoutes.routesScreenEditProfile));
      case AppRoutes.routesScreenSettings:
        return MaterialPageRoute(builder: (_) => const ScreenSettings(), settings: const RouteSettings(name: AppRoutes.routesScreenSettings));
      case AppRoutes.routesScreenChangePassword:
        return MaterialPageRoute(builder: (_) => const ScreenChangePassword(), settings: const RouteSettings(name: AppRoutes.routesScreenChangePassword));
      case AppRoutes.routesScreenFeedback:
        return MaterialPageRoute(builder: (_) => const ScreenFeedback(), settings: const RouteSettings(name: AppRoutes.routesScreenFeedback));
      case AppRoutes.routesScreenPreferences:
        return MaterialPageRoute(builder: (_) => const ScreenPreferences(), settings: const RouteSettings(name: AppRoutes.routesScreenPreferences));
      case AppRoutes.routesScreenFavourite:
        return MaterialPageRoute(builder: (_) =>  ScreenFavourites(modelRequestDataTransfer: args as ModelRequestDataTransfer,), settings: const RouteSettings(name: AppRoutes.routesScreenFavourite));
      case AppRoutes.routesScreenChats:
        return MaterialPageRoute(builder: (_) => ScreenChatsModule(messageRoomRequestData: args as MessageRoomRequestData,), settings: const RouteSettings(name: AppRoutes.routesScreenChats));
      case AppRoutes.routesScreenCms:
        return MaterialPageRoute(
            builder: (_) => ScreenHtmlContent(
                  slug: args as String,
                ),
            settings: const RouteSettings(name: AppRoutes.routesScreenCms));
      default:
        return MaterialPageRoute(builder: (_) => const ScreenSplash(), settings: const RouteSettings(name: AppRoutes.routesSplash));
    }
  }
}

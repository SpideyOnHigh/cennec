import 'package:cennec/modules/core/api_service/error_model.dart';
import 'package:cennec/modules/notifications/model/model_notification.dart';
import 'package:cennec/modules/notifications/repository/repository_notifications.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/common_import.dart';

part 'notifications_list_event.dart';
part 'notifications_list_state.dart';

class NotificationsListBloc extends Bloc<NotificationsListEvent, NotificationsListState> {
  NotificationsListBloc({
    required RepositoryNotification repositoryNotification,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryNotification = repositoryNotification,
        mApiProvider = apiProvider,
        mClient = client,
        super(NotificationsListInitial()) {
    on<NotificationsList>(updateNotification);
  }

  final RepositoryNotification mRepositoryNotification;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void updateNotification(
      NotificationsList event,
      Emitter<NotificationsListState> emit,
      ) async {
    /// Emitting an NotificationLoading state.
    emit(NotificationsListLoading());
    try {
      /// This is a way to handle the response from the API call.
      ModelNotificationContent modelNotificationContent =
      await mRepositoryNotification.getNotification(
        event.url,
        await mApiProvider.getHeaderValueWithToken(),
        mApiProvider,
        mClient,
      );
      if (modelNotificationContent.success == true) {
        emit(NotificationsListResponse(
          modelNotificationContent: modelNotificationContent,
        ));
      } else {
        emit(NotificationsListFailure(errorMessage: modelNotificationContent.error ?? ModelError()));
      }
    } on SocketException {
      emit( NotificationsListFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
    } catch (e) {
      printWrapped("error $e");
      if (e.toString().contains(getTranslate(ValidationString.validationXMLHttpRequest))) {
        emit(  NotificationsListFailure(errorMessage: ModelError(generalError: ValidationString.validationNoInternetFound)));
      } else {
        emit(  NotificationsListFailure(errorMessage:ModelError(generalError: ValidationString.validationInternalServerIssue)));
      }
    }
  }
}